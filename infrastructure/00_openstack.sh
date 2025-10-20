#!/bin/bash

source common.sh

run_command "openstack image list | grep Ubuntu-18.04-Marketplace-Basic-v2"

read

run_command "openstack network list | grep ext"
