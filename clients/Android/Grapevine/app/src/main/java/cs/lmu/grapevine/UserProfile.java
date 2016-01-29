package cs.lmu.grapevine;

import android.app.Activity;
import android.content.SharedPreferences;
import org.apache.commons.lang3.NotImplementedException;

/**
 * Class for managing user login persistance and accessing stored info of logged in user
 */
public class UserProfile {
    public static final String  USER_INFO                  = "USER_INFO";
    public static final String  USER_FIRST_NAME            = "USER_FIRST_NAME";
    public static final String  USER_LAST_NAME             = "USER_LAST_NAME";
    public static final String  USER_ID                    = "USER_ID";
    public static final String  AUTHENTICATION_TOKEN       = "AUTHENTICATION_TOKEN";
    public static final String  LOGGED_IN                  = "LOGGED_IN";

    public static boolean isLoggedIn(Activity activity) {
        return getBoolean(LOGGED_IN, activity);
    }

    public static String getFirstName(Activity activity) {
        return getString(USER_FIRST_NAME, activity);
    }

    public static String getLastName(Activity activity) {
        return getString(USER_LAST_NAME, activity);
    }

    public static String getAuthenticationToken(Activity activity) {
        return getString(AUTHENTICATION_TOKEN, activity);
    }

    public static int getUserId(Activity activity) {
        return getInt(USER_ID, activity);
    }

    public static boolean hasValidAuthenticationToken(Activity activity) {
        throw new NotImplementedException("API does not currently return token expiration timestamp");
    }

    public static void saveFirstName(String firstName, Activity activity) {
        getEditor(activity).putString(USER_FIRST_NAME, firstName).commit();
    }

    public static void saveLastName(String lastName, Activity activity) {
        getEditor(activity).putString(USER_LAST_NAME, lastName).commit();
    }

    public static void saveAuthenticationToken(String token, Activity activity) {
        getEditor(activity).putString(AUTHENTICATION_TOKEN, token).commit();
    }

    public static void saveUserId(int userId, Activity activity) {
        getEditor(activity).putInt(USER_ID, userId).commit();
    }

    public static void saveLoginStatus(Activity activity) {
        getEditor(activity).putBoolean(LOGGED_IN, true).commit();
    }

    public static void logout(Activity activity) {
        getEditor(activity).clear().commit();
        getEditor(activity).putBoolean(LOGGED_IN, false).commit();
    }

    private static String getString(String info, Activity activity) {
        return getPreferences(activity).getString(info, null);
    }

    private static boolean getBoolean(String info, Activity activity) {
        return getPreferences(activity).getBoolean(info, false);
    }

    private static int getInt(String info, Activity activity) {
        return getPreferences(activity).getInt(info, 0);
    }

    private static SharedPreferences getPreferences(Activity activity) {
        return activity.getSharedPreferences(USER_INFO, Activity.MODE_PRIVATE);
    }

    private static SharedPreferences.Editor getEditor(Activity activity) {
        return getPreferences(activity).edit();
    }
}