#!/bin/sh

python -c "from Foundation import CFPreferencesCopyAppValue; print CFPreferencesCopyAppValue('key', 'com.domain.app')"

exit 0