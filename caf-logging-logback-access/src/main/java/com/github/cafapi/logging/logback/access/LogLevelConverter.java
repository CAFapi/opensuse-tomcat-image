/*
 * Copyright 2017-2020 Micro Focus or one of its affiliates.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.github.cafapi.logging.logback.access;

import ch.qos.logback.access.pattern.AccessConverter;
import ch.qos.logback.access.spi.IAccessEvent;

public final class LogLevelConverter extends AccessConverter
{
    @Override
    public String convert(final IAccessEvent event)
    {
        final int statusCode = event.getStatusCode();
        if (statusCode >= 400 && statusCode <= 499) {
            return "WARN";
        } else if (statusCode >= 500 && statusCode <= 599) {
            return "ERROR";
        } else {
            return "INFO";
        }
    }
}
