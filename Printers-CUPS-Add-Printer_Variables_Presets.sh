#!/bin/sh

#Set Printer Name
PRINTER="${4}"
PRINTER_UI_NAME="${PRINTER}"

#Set Print Server or Printer Direct Host/IP
NETPRINT="${5}"

#Set Printer Location
LOCATION="${6}"

#Set Printer Queue
QUEUE="${7}"

#Set Driver Path
DRIVER="${8}"

#Remove Printer#
/usr/sbin/lpadmin -x "${PRINTER}"

sleep 2

#Printer install script - comment out the methods you dont want to use; use one at a time.

#Add Printer via Print Server#
/usr/sbin/lpadmin -p "$PRINTER" -D "${PRINTER_UI_NAME}" -E -v smb://"$NETPRINT"/"${QUEUE}" -P "$DRIVER" -L "$LOCATION" -o auth-info-required=negotiate -o printer-is-shared=false -o Option1="${9}" -o Option5=3TrayDrawer -o Option6=Installed -o ARCMode=CMBW -o Duplex=DuplexNoTumble

#Add Printer via LPD#
#/usr/sbin/lpadmin -p "$PRINTER" -D "${PRINTER_UI_NAME}" -E -v lpd://"$NETPRINT"/"${QUEUE}" -P "$DRIVER" -L "$LOCATION" -o auth-info-required=negotiate -o printer-is-shared=false

#Add Printer via IPP Everywhere/AirPrint
#/usr/sbin/lpadmin -p "$PRINTER" -D "${PRINTER_UI_NAME}" -E -v ipp://"${NETPRINT}"/ipp/print -m everywhere -L "$LOCATION" -o auth-info-required=negotiate -o printer-is-shared=false

sleep 2

#Set UseLastPrinter to False EVERYWHERE#

for USER_HOME in /Users/*
  do
    USER_UID=$(basename "${USER_HOME}")
    if [ ! "${USER_UID}" = "Shared" ]
    then
      if [ ! -d "${USER_HOME}"/Library/Preferences ]
      then
        mkdir -p "${USER_HOME}"/Library/Preferences
        chown "${USER_UID}" "${USER_HOME}"/Library
        chown "${USER_UID}" "${USER_HOME}"/Library/Preferences
      fi
      if [ -d "${USER_HOME}"/Library/Preferences ]
      then
        /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/org.cups.PrintingPrefs.plist UseLastPrinter -bool FALSE
        chown "${USER_UID}" "${USER_HOME}"/Library/Preferences/org.cups.PrintingPrefs.plist
      fi
    fi
  done


#Configure Printer Presets for each user#
# Create new presets on a machine and copy desired preset from 
# ~/Library/Preferences/com.apple.print.custompresets.forprinter.${PRINTER}.plist
# into the script to replace the whole file on deployment

for USER_HOME in /Users/*
  do
    USER_UID=$(basename "${USER_HOME}")
    if [ ! "${USER_UID}" = "Shared" ]
    then
      if [ ! -d "${USER_HOME}"/Library/Preferences ]
      then
        mkdir -p "${USER_HOME}"/Library/Preferences
        chown "${USER_UID}" "${USER_HOME}"/Library
        chown "${USER_UID}" "${USER_HOME}"/Library/Preferences
      fi
      if [ -d "${USER_HOME}"/Library/Preferences ]
      then

cat > "${USER_HOME}/Library/Preferences/com.apple.print.custompresets.forprinter.${PRINTER}.plist" <<'PLIST'

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Double Sided - Black and White</key>
	<dict>
		<key>com.apple.print.preset.behavior</key>
		<integer>0</integer>
		<key>com.apple.print.preset.id</key>
		<string>Double Sided - Black and White</string>
		<key>com.apple.print.preset.settings</key>
		<dict>
			<key>Duplex</key>
			<string>DuplexNoTumble</string>
			<key>DuplexBindingEdge</key>
			<integer>2</integer>
			<key>com.apple.print.PMPresetUsed</key>
			<string>Default Settings</string>
			<key>com.apple.print.PageToPaperMappingAllowScalingUp</key>
			<true/>
			<key>com.apple.print.PrintSettings.PMColorSpaceModel</key>
			<integer>3</integer>
			<key>com.apple.print.PrintSettings.PMDuplexing</key>
			<integer>2</integer>
			<key>com.apple.print.subTicket.paper_info_ticket</key>
			<dict>
				<key>PMPPDPaperCodeName</key>
				<string>A4</string>
				<key>PMPPDTranslationStringPaperName</key>
				<string>A4</string>
				<key>PMTiogaPaperName</key>
				<string>iso-a4</string>
				<key>com.apple.print.PaperInfo.PMPPDPaperDimension</key>
				<array>
					<integer>0</integer>
					<integer>0</integer>
					<real>595</real>
					<real>842</real>
				</array>
				<key>com.apple.print.PaperInfo.PMPaperName</key>
				<string>iso-a4</string>
				<key>com.apple.print.PaperInfo.PMUnadjustedPageRect</key>
				<array>
					<integer>0</integer>
					<integer>0</integer>
					<real>818</real>
					<real>571</real>
				</array>
				<key>com.apple.print.PaperInfo.PMUnadjustedPaperRect</key>
				<array>
					<real>-12</real>
					<real>-12</real>
					<real>830</real>
					<real>583</real>
				</array>
				<key>com.apple.print.PaperInfo.ppd.PMPaperName</key>
				<string>A4</string>
				<key>com.apple.print.ticket.type</key>
				<string>com.apple.print.PaperInfoTicket</string>
			</dict>
		</dict>
	</dict>
	<key>Double Sided - Black and White - Booklet</key>
	<dict>
		<key>com.apple.print.preset.behavior</key>
		<integer>0</integer>
		<key>com.apple.print.preset.id</key>
		<string>Double Sided - Black and White - Booklet</string>
		<key>com.apple.print.preset.settings</key>
		<dict>
			<key>ARCCMYKS</key>
			<string>False</string>
			<key>ARCIntent</key>
			<string>IPerceptual</string>
			<key>ARCMode</key>
			<string>CMBW</string>
			<key>ARCNGray</key>
			<string>NGray3</string>
			<key>ARCOProfile</key>
			<string>OPDefault</string>
			<key>ARCOType</key>
			<string>COTStandard</string>
			<key>ARCOverp</key>
			<string>True</string>
			<key>ARCPPriority</key>
			<string>HQuality</string>
			<key>ARCPureB</key>
			<string>PureB2</string>
			<key>ARCRetainCMYK</key>
			<string>False</string>
			<key>ARCSProfile</key>
			<string>SPGamma22</string>
			<key>ARCScreen</key>
			<string>SDefault</string>
			<key>ARCSharpness</key>
			<string>SNone</string>
			<key>ARCSimProfile</key>
			<string>ISDefault</string>
			<key>ARCTrapping</key>
			<string>TNone</string>
			<key>ARColorSync</key>
			<string>False</string>
			<key>ARPrintRelease</key>
			<string>False</string>
			<key>ARSaveToner</key>
			<string>False</string>
			<key>ARStaple</key>
			<string>Staple2</string>
			<key>DuplexBindingEdge</key>
			<integer>2</integer>
			<key>OutputBin</key>
			<string>Output4</string>
			<key>com.apple.print.PMPresetUsed</key>
			<string>Default Settings</string>
			<key>com.apple.print.PageToPaperMappingAllowScalingUp</key>
			<true/>
			<key>com.apple.print.PrintSettings.PMColorSpaceModel</key>
			<integer>3</integer>
			<key>com.apple.print.PrintSettings.PMDuplexing</key>
			<integer>2</integer>
			<key>com.apple.print.subTicket.paper_info_ticket</key>
			<dict>
				<key>PMPPDPaperCodeName</key>
				<string>A4</string>
				<key>PMPPDTranslationStringPaperName</key>
				<string>A4</string>
				<key>PMTiogaPaperName</key>
				<string>iso-a4</string>
				<key>com.apple.print.PaperInfo.PMPPDPaperDimension</key>
				<array>
					<integer>0</integer>
					<integer>0</integer>
					<real>595</real>
					<real>842</real>
				</array>
				<key>com.apple.print.PaperInfo.PMPaperName</key>
				<string>iso-a4</string>
				<key>com.apple.print.PaperInfo.PMUnadjustedPageRect</key>
				<array>
					<integer>0</integer>
					<integer>0</integer>
					<real>818</real>
					<real>571</real>
				</array>
				<key>com.apple.print.PaperInfo.PMUnadjustedPaperRect</key>
				<array>
					<real>-12</real>
					<real>-12</real>
					<real>830</real>
					<real>583</real>
				</array>
				<key>com.apple.print.PaperInfo.ppd.PMPaperName</key>
				<string>A4</string>
				<key>com.apple.print.ticket.type</key>
				<string>com.apple.print.PaperInfoTicket</string>
			</dict>
			<key>jp.co.sharp.print.PrintSettings.Authentication</key>
			<string>1</string>
			<key>jp.co.sharp.print.PrintSettings.co.cr2</key>
			<string>2</string>
			<key>jp.co.sharp.print.PrintSettings.fileNameAsJobKey</key>
			<string>1</string>
			<key>jp.co.sharp.print.PrintSettings.filing</key>
			<string>0</string>
			<key>jp.co.sharp.print.PrintSettings.holdButton</key>
			<string>0</string>
			<key>jp.co.sharp.print.PrintSettings.jobSuspend</key>
			<string>0</string>
			<key>jp.co.sharp.print.PrintSettings.spoolTime</key>
			<string>5468752C203233204A756C20323032362031323A31323A3333202B31303030</string>
			<key>jp.co.sharp.print.PrintSettings.userName</key>
			<string>4161726F6E20506F6C6C6579</string>
			<key>jp.co.sharp.print.PrintSettings.userName2</key>
			<string>4161726F6E20506F6C6C6579</string>
			<key>jp.co.sharp.print.PrintSettings.userName31</key>
			<string>4161726F6E20506F6C6C6579</string>
		</dict>
	</dict>
	<key>Double Sided - Black and White - Staple</key>
	<dict>
		<key>com.apple.print.preset.behavior</key>
		<integer>0</integer>
		<key>com.apple.print.preset.id</key>
		<string>Double Sided - Black and White - Staple</string>
		<key>com.apple.print.preset.settings</key>
		<dict>
			<key>ARCCMYKS</key>
			<string>False</string>
			<key>ARCIntent</key>
			<string>IPerceptual</string>
			<key>ARCMode</key>
			<string>CMBW</string>
			<key>ARCNGray</key>
			<string>NGray3</string>
			<key>ARCOProfile</key>
			<string>OPDefault</string>
			<key>ARCOType</key>
			<string>COTStandard</string>
			<key>ARCOverp</key>
			<string>True</string>
			<key>ARCPPriority</key>
			<string>HQuality</string>
			<key>ARCPureB</key>
			<string>PureB2</string>
			<key>ARCRetainCMYK</key>
			<string>False</string>
			<key>ARCSProfile</key>
			<string>SPGamma22</string>
			<key>ARCScreen</key>
			<string>SDefault</string>
			<key>ARCSharpness</key>
			<string>SNone</string>
			<key>ARCSimProfile</key>
			<string>ISDefault</string>
			<key>ARCTrapping</key>
			<string>TNone</string>
			<key>ARColorSync</key>
			<string>False</string>
			<key>ARPrintRelease</key>
			<string>False</string>
			<key>ARSaveToner</key>
			<string>False</string>
			<key>ARStaple</key>
			<string>Staple1</string>
			<key>DuplexBindingEdge</key>
			<integer>2</integer>
			<key>OutputBin</key>
			<string>Output4</string>
			<key>com.apple.print.PMPresetUsed</key>
			<string>Default Settings</string>
			<key>com.apple.print.PageToPaperMappingAllowScalingUp</key>
			<true/>
			<key>com.apple.print.PrintSettings.PMColorSpaceModel</key>
			<integer>3</integer>
			<key>com.apple.print.PrintSettings.PMDuplexing</key>
			<integer>2</integer>
			<key>com.apple.print.subTicket.paper_info_ticket</key>
			<dict>
				<key>PMPPDPaperCodeName</key>
				<string>A4</string>
				<key>PMPPDTranslationStringPaperName</key>
				<string>A4</string>
				<key>PMTiogaPaperName</key>
				<string>iso-a4</string>
				<key>com.apple.print.PaperInfo.PMPPDPaperDimension</key>
				<array>
					<integer>0</integer>
					<integer>0</integer>
					<real>595</real>
					<real>842</real>
				</array>
				<key>com.apple.print.PaperInfo.PMPaperName</key>
				<string>iso-a4</string>
				<key>com.apple.print.PaperInfo.PMUnadjustedPageRect</key>
				<array>
					<integer>0</integer>
					<integer>0</integer>
					<real>818</real>
					<real>571</real>
				</array>
				<key>com.apple.print.PaperInfo.PMUnadjustedPaperRect</key>
				<array>
					<real>-12</real>
					<real>-12</real>
					<real>830</real>
					<real>583</real>
				</array>
				<key>com.apple.print.PaperInfo.ppd.PMPaperName</key>
				<string>A4</string>
				<key>com.apple.print.ticket.type</key>
				<string>com.apple.print.PaperInfoTicket</string>
			</dict>
			<key>jp.co.sharp.print.PrintSettings.Authentication</key>
			<string>1</string>
			<key>jp.co.sharp.print.PrintSettings.co.cr2</key>
			<string>2</string>
			<key>jp.co.sharp.print.PrintSettings.fileNameAsJobKey</key>
			<string>1</string>
			<key>jp.co.sharp.print.PrintSettings.filing</key>
			<string>0</string>
			<key>jp.co.sharp.print.PrintSettings.holdButton</key>
			<string>0</string>
			<key>jp.co.sharp.print.PrintSettings.jobSuspend</key>
			<string>0</string>
			<key>jp.co.sharp.print.PrintSettings.spoolTime</key>
			<string>5468752C203233204A756C20323032362031323A31323A3333202B31303030</string>
			<key>jp.co.sharp.print.PrintSettings.userName</key>
			<string>4161726F6E20506F6C6C6579</string>
			<key>jp.co.sharp.print.PrintSettings.userName2</key>
			<string>4161726F6E20506F6C6C6579</string>
			<key>jp.co.sharp.print.PrintSettings.userName31</key>
			<string>4161726F6E20506F6C6C6579</string>
		</dict>
	</dict>
	<key>Double Sided - Colour</key>
	<dict>
		<key>com.apple.print.preset.behavior</key>
		<integer>0</integer>
		<key>com.apple.print.preset.id</key>
		<string>Double Sided - Colour</string>
		<key>com.apple.print.preset.settings</key>
		<dict>
			<key>ARCCMYKS</key>
			<string>False</string>
			<key>ARCIntent</key>
			<string>IPerceptual</string>
			<key>ARCMode</key>
			<string>CMColor</string>
			<key>ARCNGray</key>
			<string>NGray3</string>
			<key>ARCOProfile</key>
			<string>OPDefault</string>
			<key>ARCOType</key>
			<string>COTStandard</string>
			<key>ARCOverp</key>
			<string>True</string>
			<key>ARCPPriority</key>
			<string>HQuality</string>
			<key>ARCPureB</key>
			<string>PureB2</string>
			<key>ARCRetainCMYK</key>
			<string>False</string>
			<key>ARCSProfile</key>
			<string>SPGamma22</string>
			<key>ARCScreen</key>
			<string>SDefault</string>
			<key>ARCSharpness</key>
			<string>SNone</string>
			<key>ARCSimProfile</key>
			<string>ISDefault</string>
			<key>ARCTrapping</key>
			<string>TNone</string>
			<key>ARColorSync</key>
			<string>False</string>
			<key>ARSaveToner</key>
			<string>False</string>
			<key>DuplexBindingEdge</key>
			<integer>2</integer>
			<key>com.apple.print.PMPresetUsed</key>
			<string>Default Settings</string>
			<key>com.apple.print.PageToPaperMappingAllowScalingUp</key>
			<true/>
			<key>com.apple.print.PrintSettings.PMColorSpaceModel</key>
			<integer>3</integer>
			<key>com.apple.print.PrintSettings.PMDuplexing</key>
			<integer>2</integer>
			<key>com.apple.print.subTicket.paper_info_ticket</key>
			<dict>
				<key>PMPPDPaperCodeName</key>
				<string>A4</string>
				<key>PMPPDTranslationStringPaperName</key>
				<string>A4</string>
				<key>PMTiogaPaperName</key>
				<string>iso-a4</string>
				<key>com.apple.print.PaperInfo.PMPPDPaperDimension</key>
				<array>
					<integer>0</integer>
					<integer>0</integer>
					<real>595</real>
					<real>842</real>
				</array>
				<key>com.apple.print.PaperInfo.PMPaperName</key>
				<string>iso-a4</string>
				<key>com.apple.print.PaperInfo.PMUnadjustedPageRect</key>
				<array>
					<integer>0</integer>
					<integer>0</integer>
					<real>818</real>
					<real>571</real>
				</array>
				<key>com.apple.print.PaperInfo.PMUnadjustedPaperRect</key>
				<array>
					<real>-12</real>
					<real>-12</real>
					<real>830</real>
					<real>583</real>
				</array>
				<key>com.apple.print.PaperInfo.ppd.PMPaperName</key>
				<string>A4</string>
				<key>com.apple.print.ticket.type</key>
				<string>com.apple.print.PaperInfoTicket</string>
			</dict>
			<key>jp.co.sharp.print.PrintSettings.co.cr2</key>
			<string>2</string>
		</dict>
	</dict>
	<key>Double Sided - Colour - Booklet</key>
	<dict>
		<key>com.apple.print.preset.behavior</key>
		<integer>0</integer>
		<key>com.apple.print.preset.id</key>
		<string>Double Sided - Colour - Booklet</string>
		<key>com.apple.print.preset.settings</key>
		<dict>
			<key>ARCCMYKS</key>
			<string>False</string>
			<key>ARCIntent</key>
			<string>IPerceptual</string>
			<key>ARCMode</key>
			<string>CMColor</string>
			<key>ARCNGray</key>
			<string>NGray3</string>
			<key>ARCOProfile</key>
			<string>OPDefault</string>
			<key>ARCOType</key>
			<string>COTStandard</string>
			<key>ARCOverp</key>
			<string>True</string>
			<key>ARCPPriority</key>
			<string>HQuality</string>
			<key>ARCPureB</key>
			<string>PureB2</string>
			<key>ARCRetainCMYK</key>
			<string>False</string>
			<key>ARCSProfile</key>
			<string>SPGamma22</string>
			<key>ARCScreen</key>
			<string>SDefault</string>
			<key>ARCSharpness</key>
			<string>SNone</string>
			<key>ARCSimProfile</key>
			<string>ISDefault</string>
			<key>ARCTrapping</key>
			<string>TNone</string>
			<key>ARColorSync</key>
			<string>False</string>
			<key>ARPrintRelease</key>
			<string>False</string>
			<key>ARSaveToner</key>
			<string>False</string>
			<key>ARStaple</key>
			<string>Staple2</string>
			<key>DuplexBindingEdge</key>
			<integer>2</integer>
			<key>OutputBin</key>
			<string>Output4</string>
			<key>com.apple.print.PMPresetUsed</key>
			<string>Default Settings</string>
			<key>com.apple.print.PageToPaperMappingAllowScalingUp</key>
			<true/>
			<key>com.apple.print.PrintSettings.PMColorSpaceModel</key>
			<integer>3</integer>
			<key>com.apple.print.PrintSettings.PMDuplexing</key>
			<integer>2</integer>
			<key>com.apple.print.subTicket.paper_info_ticket</key>
			<dict>
				<key>PMPPDPaperCodeName</key>
				<string>A4</string>
				<key>PMPPDTranslationStringPaperName</key>
				<string>A4</string>
				<key>PMTiogaPaperName</key>
				<string>iso-a4</string>
				<key>com.apple.print.PaperInfo.PMPPDPaperDimension</key>
				<array>
					<integer>0</integer>
					<integer>0</integer>
					<real>595</real>
					<real>842</real>
				</array>
				<key>com.apple.print.PaperInfo.PMPaperName</key>
				<string>iso-a4</string>
				<key>com.apple.print.PaperInfo.PMUnadjustedPageRect</key>
				<array>
					<integer>0</integer>
					<integer>0</integer>
					<real>818</real>
					<real>571</real>
				</array>
				<key>com.apple.print.PaperInfo.PMUnadjustedPaperRect</key>
				<array>
					<real>-12</real>
					<real>-12</real>
					<real>830</real>
					<real>583</real>
				</array>
				<key>com.apple.print.PaperInfo.ppd.PMPaperName</key>
				<string>A4</string>
				<key>com.apple.print.ticket.type</key>
				<string>com.apple.print.PaperInfoTicket</string>
			</dict>
			<key>jp.co.sharp.print.PrintSettings.Authentication</key>
			<string>1</string>
			<key>jp.co.sharp.print.PrintSettings.co.cr2</key>
			<string>2</string>
			<key>jp.co.sharp.print.PrintSettings.fileNameAsJobKey</key>
			<string>1</string>
			<key>jp.co.sharp.print.PrintSettings.filing</key>
			<string>0</string>
			<key>jp.co.sharp.print.PrintSettings.holdButton</key>
			<string>0</string>
			<key>jp.co.sharp.print.PrintSettings.jobSuspend</key>
			<string>0</string>
			<key>jp.co.sharp.print.PrintSettings.spoolTime</key>
			<string>5468752C203233204A756C20323032362031323A31323A3333202B31303030</string>
			<key>jp.co.sharp.print.PrintSettings.userName</key>
			<string>4161726F6E20506F6C6C6579</string>
			<key>jp.co.sharp.print.PrintSettings.userName2</key>
			<string>4161726F6E20506F6C6C6579</string>
			<key>jp.co.sharp.print.PrintSettings.userName31</key>
			<string>4161726F6E20506F6C6C6579</string>
		</dict>
	</dict>
	<key>Double Sided - Colour - Staple</key>
	<dict>
		<key>com.apple.print.preset.behavior</key>
		<integer>0</integer>
		<key>com.apple.print.preset.id</key>
		<string>Double Sided - Colour - Staple</string>
		<key>com.apple.print.preset.settings</key>
		<dict>
			<key>ARCCMYKS</key>
			<string>False</string>
			<key>ARCIntent</key>
			<string>IPerceptual</string>
			<key>ARCMode</key>
			<string>CMColor</string>
			<key>ARCNGray</key>
			<string>NGray3</string>
			<key>ARCOProfile</key>
			<string>OPDefault</string>
			<key>ARCOType</key>
			<string>COTStandard</string>
			<key>ARCOverp</key>
			<string>True</string>
			<key>ARCPPriority</key>
			<string>HQuality</string>
			<key>ARCPureB</key>
			<string>PureB2</string>
			<key>ARCRetainCMYK</key>
			<string>False</string>
			<key>ARCSProfile</key>
			<string>SPGamma22</string>
			<key>ARCScreen</key>
			<string>SDefault</string>
			<key>ARCSharpness</key>
			<string>SNone</string>
			<key>ARCSimProfile</key>
			<string>ISDefault</string>
			<key>ARCTrapping</key>
			<string>TNone</string>
			<key>ARColorSync</key>
			<string>False</string>
			<key>ARPrintRelease</key>
			<string>False</string>
			<key>ARSaveToner</key>
			<string>False</string>
			<key>ARStaple</key>
			<string>Staple1</string>
			<key>DuplexBindingEdge</key>
			<integer>2</integer>
			<key>OutputBin</key>
			<string>Output4</string>
			<key>com.apple.print.PMPresetUsed</key>
			<string>Default Settings</string>
			<key>com.apple.print.PageToPaperMappingAllowScalingUp</key>
			<true/>
			<key>com.apple.print.PrintSettings.PMColorSpaceModel</key>
			<integer>3</integer>
			<key>com.apple.print.PrintSettings.PMDuplexing</key>
			<integer>2</integer>
			<key>com.apple.print.subTicket.paper_info_ticket</key>
			<dict>
				<key>PMPPDPaperCodeName</key>
				<string>A4</string>
				<key>PMPPDTranslationStringPaperName</key>
				<string>A4</string>
				<key>PMTiogaPaperName</key>
				<string>iso-a4</string>
				<key>com.apple.print.PaperInfo.PMPPDPaperDimension</key>
				<array>
					<integer>0</integer>
					<integer>0</integer>
					<real>595</real>
					<real>842</real>
				</array>
				<key>com.apple.print.PaperInfo.PMPaperName</key>
				<string>iso-a4</string>
				<key>com.apple.print.PaperInfo.PMUnadjustedPageRect</key>
				<array>
					<integer>0</integer>
					<integer>0</integer>
					<real>818</real>
					<real>571</real>
				</array>
				<key>com.apple.print.PaperInfo.PMUnadjustedPaperRect</key>
				<array>
					<real>-12</real>
					<real>-12</real>
					<real>830</real>
					<real>583</real>
				</array>
				<key>com.apple.print.PaperInfo.ppd.PMPaperName</key>
				<string>A4</string>
				<key>com.apple.print.ticket.type</key>
				<string>com.apple.print.PaperInfoTicket</string>
			</dict>
			<key>jp.co.sharp.print.PrintSettings.Authentication</key>
			<string>1</string>
			<key>jp.co.sharp.print.PrintSettings.co.cr2</key>
			<string>2</string>
			<key>jp.co.sharp.print.PrintSettings.fileNameAsJobKey</key>
			<string>1</string>
			<key>jp.co.sharp.print.PrintSettings.filing</key>
			<string>0</string>
			<key>jp.co.sharp.print.PrintSettings.holdButton</key>
			<string>0</string>
			<key>jp.co.sharp.print.PrintSettings.jobSuspend</key>
			<string>0</string>
			<key>jp.co.sharp.print.PrintSettings.spoolTime</key>
			<string>5468752C203233204A756C20323032362031323A31323A3333202B31303030</string>
			<key>jp.co.sharp.print.PrintSettings.userName</key>
			<string>4161726F6E20506F6C6C6579</string>
			<key>jp.co.sharp.print.PrintSettings.userName2</key>
			<string>4161726F6E20506F6C6C6579</string>
			<key>jp.co.sharp.print.PrintSettings.userName31</key>
			<string>4161726F6E20506F6C6C6579</string>
		</dict>
	</dict>
	<key>com.apple.print.customPresetsInfo</key>
	<array>
		<dict>
			<key>PresetBehavior</key>
			<integer>0</integer>
			<key>PresetName</key>
			<string>Double Sided - Black and White</string>
		</dict>
		<dict>
			<key>PresetBehavior</key>
			<integer>0</integer>
			<key>PresetName</key>
			<string>Double Sided - Colour</string>
		</dict>
		<dict>
			<key>PresetBehavior</key>
			<integer>0</integer>
			<key>PresetName</key>
			<string>Double Sided - Colour - Staple</string>
		</dict>
		<dict>
			<key>PresetBehavior</key>
			<integer>0</integer>
			<key>PresetName</key>
			<string>Double Sided - Colour - Booklet</string>
		</dict>
		<dict>
			<key>PresetBehavior</key>
			<integer>0</integer>
			<key>PresetName</key>
			<string>Double Sided - Black and White - Booklet</string>
		</dict>
		<dict>
			<key>PresetBehavior</key>
			<integer>0</integer>
			<key>PresetName</key>
			<string>Double Sided - Black and White - Staple</string>
		</dict>
	</array>
	<key>com.apple.print.lastPresetUsedPrefType</key>
	<integer>0</integer>
	<key>com.apple.print.v2.lastUsedSettingsPref</key>
	<dict>
		<key>ARCCMYKS</key>
		<string>False</string>
		<key>ARCIntent</key>
		<string>IPerceptual</string>
		<key>ARCMode</key>
		<string>CMBW</string>
		<key>ARCNGray</key>
		<string>NGray3</string>
		<key>ARCOProfile</key>
		<string>OPDefault</string>
		<key>ARCOType</key>
		<string>COTStandard</string>
		<key>ARCOverp</key>
		<string>True</string>
		<key>ARCPPriority</key>
		<string>HQuality</string>
		<key>ARCPureB</key>
		<string>PureB2</string>
		<key>ARCRetainCMYK</key>
		<string>False</string>
		<key>ARCSProfile</key>
		<string>SPGamma22</string>
		<key>ARCScreen</key>
		<string>SDefault</string>
		<key>ARCSharpness</key>
		<string>SNone</string>
		<key>ARCSimProfile</key>
		<string>ISDefault</string>
		<key>ARCTrapping</key>
		<string>TNone</string>
		<key>ARColorSync</key>
		<string>False</string>
		<key>ARPrintRelease</key>
		<string>False</string>
		<key>ARSaveToner</key>
		<string>False</string>
		<key>ARwmColor</key>
		<string>WmRed</string>
		<key>ARwmFont</key>
		<string>ARF00</string>
		<key>ARwmLocation</key>
		<string>False</string>
		<key>ARwmOnOff</key>
		<string>False</string>
		<key>ARwmOutline</key>
		<string>False</string>
		<key>ARwmText</key>
		<string>WMText1</string>
		<key>ARwmTransparent</key>
		<string>Trans50</string>
		<key>com.apple.print.DialogDismissedBy</key>
		<string>Print</string>
		<key>com.apple.print.PDEsUsed</key>
		<string>Preview</string>
		<key>com.apple.print.PageToPaperMappingAllowScalingUp</key>
		<true/>
		<key>com.apple.print.PrintSettings.PMColorSpaceModel</key>
		<integer>3</integer>
		<key>com.apple.print.PrintSettings.PMDuplexing</key>
		<integer>1</integer>
		<key>com.apple.print.pageRange</key>
		<string>All 6 Pages</string>
		<key>com.apple.print.subTicket.paper_info_ticket</key>
		<dict>
			<key>PMPPDPaperCodeName</key>
			<string>A4</string>
			<key>PMPPDTranslationStringPaperName</key>
			<string>A4</string>
			<key>PMTiogaPaperName</key>
			<string>iso-a4</string>
			<key>com.apple.print.PaperInfo.PMPPDPaperDimension</key>
			<array>
				<integer>0</integer>
				<integer>0</integer>
				<real>595</real>
				<real>842</real>
			</array>
			<key>com.apple.print.PaperInfo.PMPaperName</key>
			<string>iso-a4</string>
			<key>com.apple.print.PaperInfo.PMUnadjustedPageRect</key>
			<array>
				<integer>0</integer>
				<integer>0</integer>
				<real>818</real>
				<real>571</real>
			</array>
			<key>com.apple.print.PaperInfo.PMUnadjustedPaperRect</key>
			<array>
				<real>-12</real>
				<real>-12</real>
				<real>830</real>
				<real>583</real>
			</array>
			<key>com.apple.print.PaperInfo.ppd.PMPaperName</key>
			<string>A4</string>
			<key>com.apple.print.ticket.type</key>
			<string>com.apple.print.PaperInfoTicket</string>
		</dict>
		<key>com.apple.print.totalPages</key>
		<integer>6</integer>
		<key>jp.co.sharp.print.PrintSettings.Authentication</key>
		<string>1</string>
		<key>jp.co.sharp.print.PrintSettings.bc.mainCodecb</key>
		<string>0</string>
		<key>jp.co.sharp.print.PrintSettings.bc.subCodecb</key>
		<string>0</string>
		<key>jp.co.sharp.print.PrintSettings.co.cr2</key>
		<string>2</string>
		<key>jp.co.sharp.print.PrintSettings.fileNameAsJobKey</key>
		<string>1</string>
		<key>jp.co.sharp.print.PrintSettings.filing</key>
		<string>0</string>
		<key>jp.co.sharp.print.PrintSettings.holdButton</key>
		<string>0</string>
		<key>jp.co.sharp.print.PrintSettings.jobSuspend</key>
		<string>0</string>
		<key>jp.co.sharp.print.PrintSettings.spoolTime</key>
		<string>5475652C203037204A756C20323032362031313A32333A3338202B31303030</string>
		<key>jp.co.sharp.print.PrintSettings.userName</key>
		<string>4161726F6E20506F6C6C6579</string>
		<key>jp.co.sharp.print.PrintSettings.userName2</key>
		<string>4161726F6E20506F6C6C6579</string>
		<key>jp.co.sharp.print.PrintSettings.userName31</key>
		<string>4161726F6E20506F6C6C6579</string>
		<key>jp.co.sharp.print.PrintSettings.watermarks.angle</key>
		<string>45</string>
		<key>jp.co.sharp.print.PrintSettings.watermarks.custom</key>
		<string>0</string>
		<key>jp.co.sharp.print.PrintSettings.watermarks.fontcmd</key>
		<string>userdict /ARwmFont known not {userdict /ARwmFont /Helvetica-Bold put} if</string>
		<key>jp.co.sharp.print.PrintSettings.watermarks.size</key>
		<string>48</string>
		<key>jp.co.sharp.print.PrintSettings.watermarks.textcmd</key>
		<string>userdict /ARwmText known not {userdict /ARwmText (TOP SECRET) put} if</string>
	</dict>
</dict>
</plist>


PLIST

        chown "${USER_UID}" "${USER_HOME}/Library/Preferences/com.apple.print.custompresets.forprinter.${PRINTER}.plist"
      fi
    fi
  done