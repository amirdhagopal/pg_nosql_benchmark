#!/bin/bash

################################################################################
# Copyright EnterpriseDB Cooperation
# All rights reserved.
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in
#      the documentation and/or other materials provided with the
#      distribution.
#    * Neither the name of PostgreSQL nor the names of its contributors
#      may be used to endorse or promote products derived from this
#      software without specific prior written permission.
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
#Author: Amirdha Gopal R (amirdhagopal@gmail.com)
# 
#adapted from    : https://github.com/EnterpriseDB/pg_nosql_benchmark
################################################################################
# quit on any error
set -e
# verify any  undefined shell variables
set -u


################################################################################
# function: print messages with process id
################################################################################
function process_log()
{
   echo "PID: $$ [RUNTIME: $(date +'%m-%d-%y %H:%M:%S')] ${BASENAME}: $*" >&2
}

################################################################################
# function: exit_on_error
################################################################################
function exit_on_error()
{

   process_log "ERROR: $*"
   exit 1
 }



################################################################################
# function: get_timestamp_in_nanoseconds
################################################################################
function get_timestamp_nano ()
{
    echo $(date +"%F %T.%N")
}


################################################################################
# function: get_timestamp_diff_nanoseconds
################################################################################
function get_timestamp_diff_nano ()
{
     typeset -r F_TIMESTAMP1="$1"
     typeset -r F_TIMESTAMP2="$2"
     local SECONDS_DIFF
     local NANOSECONDS_DIFF
     local SECONDS_NANO

     SECONDS_DIFF=$(echo $(date -d "${F_TIMESTAMP1}" +%s) \
                      -  $(date -d "${F_TIMESTAMP2}" +%s)|bc)
     NANOSECONDS_DIFF=$(echo $(date -d "${F_TIMESTAMP1}" +%N) \
                          -  $(date -d "${F_TIMESTAMP2}" +%N)|bc)
     SECONDS_NANO=$(echo ${SECONDS_DIFF} \* 1000000000|bc)
     printf "%d\n" $(((${SECONDS_NANO}  + ${NANOSECONDS_DIFF})))
}


################################################################################
# function: generate_json_data
################################################################################
function generate_json_rows ()
{
   typeset -r NO_OF_ROWS="$1"
   typeset -r JSONFILENAME="$2"
   typeset -r CSVFILENAME="$3"

   rm -rf ${JSONFILENAME}
   rm -rf ${CSVFILENAME}
   process_log "creating json and csv data."
   for ((i=1;i<=${NO_OF_ROWS};i++))
   do
       local RAND_RANGE=$((RANDOM % (10 - 1 + 1) + 1))
       echo '{"id":'${i}',"parent_id":'$RAND_RANGE',"name": "Name'$RAND_RANGE'","application": "App'$RAND_RANGE'","thumbnail":"thumbnail","notes":"notes","is_deleted":false}' >>${JSONFILENAME}
       echo "${i},$RAND_RANGE,'Name$RAND_RANGE','App$RAND_RANGE','thumbnail','notes',false" >>${CSVFILENAME}
   done
}

################################################################################
# print integer arrays
################################################################################
function print_result()
{
   typeset -r F_TAG="$1"
   shift
   typeset -r F_LOCALARRAY=(${@})
   typeset F_ARRAYLENGTH

   F_ARRAYLENGTH=${#F_LOCALARRAY[@]}
   printf "%20s " "${F_TAG}"
   for (( i=0 ; i < ${F_ARRAYLENGTH} ; i++ ))
   do
      printf "%14d " ${F_LOCALARRAY[${i}]}
   done
   printf "\n"
}
