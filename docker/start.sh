#!/bin/bash

# modify kivitendo configuration
[ -n "${ADMIN_PASSWORD}" ] && sed -i "s/admin_password = .*/admin_password = ${ADMIN_PASSWORD}/" /var/www/kivitendo-erp/config/kivitendo.conf
[ -n "${DB_HOST}" ] && sed -i "1s/host     = .*/host     = ${DB_HOST}/" /var/www/kivitendo-erp/config/kivitendo.conf
[ -n "${DB_PORT}" ] && sed -i "1s/port     = .*/port     = ${DB_PORT}/" /var/www/kivitendo-erp/config/kivitendo.conf
[ -n "${DB_DBNAME}" ] && sed -i "s/db       = .*/db       = ${DB_DBNAME}/" /var/www/kivitendo-erp/config/kivitendo.conf
[ -n "${DB_USER}" ] && sed -i "s/user     = .*/user     = ${DB_USER}/" /var/www/kivitendo-erp/config/kivitendo.conf
[ -n "${DB_PASSWORD}" ] && sed -i "/^\[authentication\/database\]$/,/^\[/ s/^password =.*/password = ${DB_PASSWORD}/" /var/www/kivitendo-erp/config/kivitendo.conf
[ -n "${SMTP_HOST}" ] && sed -i "s/host = .*/host = ${SMTP_HOST}/" /var/www/kivitendo-erp/config/kivitendo.conf
[ -n "${SMTP_PORT}" ] && sed -i "s/#*port = .*/port = ${SMTP_PORT}/" /var/www/kivitendo-erp/config/kivitendo.conf
[ -n "${SMTP_SECURITY}" ] && sed -i "s/security = .*/security = ${SMTP_SECURITY,,}/" /var/www/kivitendo-erp/config/kivitendo.conf
[ -n "${SMTP_USER}" ] && sed -i "s/login =.*/login = ${SMTP_USER}/" /var/www/kivitendo-erp/config/kivitendo.conf
[ -n "${SMTP_PASSWORD}" ] && sed -i "/^\[mail_delivery\]$/,/^\[/ s/^password =.*/password = ${SMTP_PASSWORD}/" /var/www/kivitendo-erp/config/kivitendo.conf

exec supervisord -n