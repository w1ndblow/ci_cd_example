#!/bin/bash

source common.sh

run_command "openstack image list | grep Ubuntu-24.04"

read

run_command "openstack network list | grep ext"
