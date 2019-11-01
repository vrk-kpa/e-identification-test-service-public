/**
 * The MIT License
 * Copyright (c) 2015 Population Register Centre
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package fi.vm.kapa.identification.testservice;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.*;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TestServiceAuthenticated extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(TestServiceAuthenticated.class);

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        Configuration cfg = new Configuration(Configuration.VERSION_2_3_23);
        cfg.setDirectoryForTemplateLoading(new File("/opt/templates"));
        cfg.setDefaultEncoding("UTF-8");
        cfg.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
        cfg.setLogTemplateExceptions(false);

        Map<String,String> values = new HashMap<>();
        putIfNotBlank(values, "KAPA_HETU", convertASCIItoUTF8(request.getHeader("nationalIdentificationNumber")));
        putIfNotBlank(values, "KAPA_FOREIGN_PERSON_ID", convertASCIItoUTF8(request.getHeader("foreignPersonIdentifier")));
        putIfNotBlank(values, "KAPA_ETUNIMET", convertASCIItoUTF8(request.getHeader("FirstName")));
        putIfNotBlank(values, "KAPA_SUKUNIMI", convertASCIItoUTF8(request.getHeader("sn")));
        putIfNotBlank(values, "KAPA_PERSON_IDENTIFIER", convertASCIItoUTF8(request.getHeader("PersonIdentifier")));
        putIfNotBlank(values, "KAPA_DATE_OF_BIRTH", convertASCIItoUTF8(request.getHeader("DateOfBirth")));
        putIfNotBlank(values, "KAPA_FAMILY_NAME", convertASCIItoUTF8(request.getHeader("FamilyName")));
        putIfNotBlank(values, "KAPA_KATU", convertASCIItoUTF8(request.getHeader("VakinainenKotimainenLahiosoiteS")));
        putIfNotBlank(values, "KAPA_POSTINUMERO", convertASCIItoUTF8(request.getHeader("VakinainenKotimainenLahiosoitePostinumero")));
        putIfNotBlank(values, "KAPA_PTP", convertASCIItoUTF8(request.getHeader("VakinainenKotimainenLahiosoitePostitoimipaikkaS")));
        putIfNotBlank(values, "KAPA_TOKEN", convertASCIItoUTF8(request.getHeader("authenticationToken")));

        Template output = cfg.getTemplate("tunnistautunut.ftlh");

        response.setCharacterEncoding("UTF-8");

        try {
            output.process(values, response.getWriter());
            response.setStatus(HttpServletResponse.SC_OK);
        } catch (TemplateException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }

        response.getWriter().flush();
        response.getWriter().close();
    }

    private void putIfNotBlank(Map<String,String> map, String key, String value) {
        if (StringUtils.isNotBlank(value)) {
            map.put(key, value);
        }
    }


    // Note: Setting UTF-8 to Tomcat AJP connector doesn't seem to solve HTTP header encoding.
    // More information:
    // https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPAttributeAccess
    // http://tomcat.apache.org/tomcat-7.0-doc/config/ajp.html#Common_Attribute
    //
    // Converts ASCII (ISO-8859-1) string to UTF-8.
    private String convertASCIItoUTF8(String value)
    {
        if (value == null || value.isEmpty()) return value;
        try {
            return new String(value.getBytes("ISO-8859-1"), "UTF-8");
        }
        catch (UnsupportedEncodingException e) {
            logger.error("Caught exception "+e.getClass().getName()+" while converting string: "+value);
            return null;
        }
    }
}
