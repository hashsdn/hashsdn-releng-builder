#!/bin/bash
# SPDX-License-Identifier: EPL-1.0
##############################################################################
# Copyright (c) 2015 The Linux Foundation and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
##############################################################################

ROBOT_VENV="/tmp/v/robot"
echo ROBOT_VENV="${ROBOT_VENV}" >> "${WORKSPACE}/env.properties"

# The --system-site-packages parameter allows us to pick up system level
# installed packages. This allows us to bake matplotlib which takes very long
# to install into the image.
virtualenv --system-site-packages "${ROBOT_VENV}"
# shellcheck disable=SC1090
source "${ROBOT_VENV}/bin/activate"

set -exu

# Make sure pip itself us up-to-date.
pip install --upgrade pip

pip install --upgrade docker-py importlib requests scapy netifaces netaddr ipaddr pyhocon
pip install --upgrade robotframework-httplibrary \
    requests==2.15.1 \
    robotframework-requests \
    robotframework-sshlibrary \
    robotframework-selenium2library \
    robotframework-pycurllibrary

# Module jsonpath is needed by current AAA idmlite suite.
pip install --upgrade jsonpath-rw

# Modules for longevity framework robot library
pip install --upgrade elasticsearch==1.7.0 elasticsearch-dsl==0.0.11

# Module for pyangbind used by lispflowmapping project
pip install --upgrade pyangbind

# Module for iso8601 datetime format
pip install --upgrade isodate

# Modules for tornado and jsonpointer used by client libraries of IoTDM project
# Note: Could be removed when client running on tools VM is used instead
#       of client libraries only.
pip install --upgrade tornado jsonpointer

# Module for TemplatedRequests.robot library
pip install --upgrade jmespath

# Module for backup-restore support library
pip install --upgrade jsonpatch

# Module OpenstackClient is needed for Netvirt CSIT jobs
# Module networking-l2gw is required for using l2gw commands with neutron client
# Module python-neutronclient is needed for certain tests run with Openstack Newton
#  that does not work with Openstack Client
pip install python-openstackclient==3.11.0
pip install networking-l2gw==11.0.0
pip install python-neutronclient==6.1.0
pip install networking-sfc

# Print installed versions.
pip install --upgrade pipdeptree
pipdeptree

# vim: sw=4 ts=4 sts=4 et ft=sh :
