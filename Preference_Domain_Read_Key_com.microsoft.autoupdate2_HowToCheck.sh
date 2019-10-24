#!/bin/sh

python -c "from Foundation import CFPreferencesCopyAppValue; print CFPreferencesCopyAppValue('HowToCheck', 'com.microsoft.autoupdate2')"

exit 0