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
package com.github.cafapi.logging.tomcat.juli;

import org.apache.juli.logging.ch.qos.logback.classic.spi.LoggingEvent;
import org.apache.juli.logging.ch.qos.logback.core.ConsoleAppender;

import com.github.cafapi.logging.common.ProcessAndThreadIdProvider;

public final class CAFTomcatConsoleAppender extends ConsoleAppender<LoggingEvent>
{

    public CAFTomcatConsoleAppender()
    {
    }

    @Override
    protected void subAppend(final LoggingEvent event)
    {
        event.setThreadName(ProcessAndThreadIdProvider.getId());
        super.subAppend(event);
    }

}
