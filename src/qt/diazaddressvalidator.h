// Copyright (c) 2011-2014 The Bitcoin Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef DIAZ_QT_DIAZADDRESSVALIDATOR_H
#define DIAZ_QT_DIAZADDRESSVALIDATOR_H

#include <QValidator>

/** Base58 entry widget validator, checks for valid characters and
 * removes some whitespace.
 */
class DiazAddressEntryValidator : public QValidator
{
    Q_OBJECT

public:
    explicit DiazAddressEntryValidator(QObject *parent);

    State validate(QString &input, int &pos) const;
};

/** Diaz address widget validator, checks for a valid diaz address.
 */
class DiazAddressCheckValidator : public QValidator
{
    Q_OBJECT

public:
    explicit DiazAddressCheckValidator(QObject *parent);

    State validate(QString &input, int &pos) const;
};

#endif // DIAZ_QT_DIAZADDRESSVALIDATOR_H
