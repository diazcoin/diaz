// Copyright (c) 2014-2018 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef DIAZ_ZMQ_ZMQCONFIG_H
#define DIAZ_ZMQ_ZMQCONFIG_H

#if defined(HAVE_CONFIG_H)
#include <config/diaz-config.h>
#endif

#include <stdarg.h>

#if ENABLE_ZMQ
#include <zmq.h>
#endif

#include <primitives/transaction.h>

void zmqError(const char *str);

#endif // DIAZ_ZMQ_ZMQCONFIG_H
