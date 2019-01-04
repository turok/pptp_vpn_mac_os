#!/bin/sh

#  RunScript.sh
#  vpn
#
#  Created by Anton Turko on 03/01/2019.
#  Copyright © 2019 Anton Turko. All rights reserved.
echo "${1}"
pppd file "${1}"
