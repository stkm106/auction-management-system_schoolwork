package uef.edu.vn.utils;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

public final class CurrencyUtils {

    private static final DecimalFormat VND_FORMAT;

    static {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(Locale.US);
        symbols.setGroupingSeparator('.');
        VND_FORMAT = new DecimalFormat("#,##0", symbols);
    }

    private CurrencyUtils() {
    }

    public static String formatVnd(double amount) {
        return VND_FORMAT.format(Math.round(amount)) + " ₫";
    }
}
