package com.sismics.util;

import com.sismics.BaseTest;
import org.junit.Assert;
import org.junit.Test;

import java.util.Locale;

/**
 * Test of {@link LocaleUtil}.
 *
 * @author tangx2872-svg
 */
public class TestLocaleUtil extends BaseTest {
    /**
     * Null or empty locale code falls back to English.
     */
    @Test
    public void getLocaleNullAndEmptyTest() {
        Assert.assertEquals(Locale.ENGLISH, LocaleUtil.getLocale(null));
        Assert.assertEquals(Locale.ENGLISH, LocaleUtil.getLocale(""));
    }

    /**
     * Language only locale code.
     */
    @Test
    public void getLocaleLanguageOnlyTest() {
        Locale locale = LocaleUtil.getLocale("fr");
        Assert.assertEquals("fr", locale.getLanguage());
        Assert.assertEquals("", locale.getCountry());
        Assert.assertEquals("", locale.getVariant());
    }

    /**
     * Language and country locale code.
     */
    @Test
    public void getLocaleLanguageCountryTest() {
        Locale locale = LocaleUtil.getLocale("zh_CN");
        Assert.assertEquals("zh", locale.getLanguage());
        Assert.assertEquals("CN", locale.getCountry());
        Assert.assertEquals("", locale.getVariant());
    }

    /**
     * Language, country and variant locale code.
     */
    @Test
    public void getLocaleLanguageCountryVariantTest() {
        Locale locale = LocaleUtil.getLocale("zh_CN_linux");
        Assert.assertEquals("zh", locale.getLanguage());
        Assert.assertEquals("CN", locale.getCountry());
        Assert.assertEquals("linux", locale.getVariant());
    }
}
