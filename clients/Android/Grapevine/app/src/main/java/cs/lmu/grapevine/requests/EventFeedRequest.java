package cs.lmu.grapevine.requests;

import android.app.Activity;

import com.android.volley.toolbox.JsonArrayRequest;
import java.util.HashMap;
import java.util.Map;
import cs.lmu.grapevine.BuildConfig;
import cs.lmu.grapevine.MainActivity;
import cs.lmu.grapevine.requests.listeners.EventErrorListener;
import cs.lmu.grapevine.requests.listeners.EventSuccessListener;

/**
 * A request to get events for a user's event feed.
 */
public class EventFeedRequest extends JsonArrayRequest {
    public static String eventRequestURL = BuildConfig.API_HOST
            + "api/v1/users/"
            + MainActivity.userId
            + "/events";

    public EventFeedRequest(Activity parentActivity) {
        super(Method.GET,
              eventRequestURL,
              null,
              new EventSuccessListener(parentActivity),
              new EventErrorListener(parentActivity)
        );
    }

    @Override
    public Map<String, String> getHeaders(){
        HashMap<String, String> eventRequestHeaders = new HashMap<>();
        eventRequestHeaders.put("x-access-token", MainActivity.authenticationToken);
        eventRequestHeaders.put("Content-Type", "application/json");

        return eventRequestHeaders;
    }
}