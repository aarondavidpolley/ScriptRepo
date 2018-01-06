#!/bin/bash

ioreg -p IOUSB | cut -d@ -f1 | cut -d+ -f2