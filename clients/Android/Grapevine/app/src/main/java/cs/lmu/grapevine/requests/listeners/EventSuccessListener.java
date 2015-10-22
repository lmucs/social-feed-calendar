package cs.lmu.grapevine.requests.listeners;

import android.app.Activity;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;
import com.android.volley.Response;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import org.json.JSONArray;
import java.util.ArrayList;
import java.util.List;
import cs.lmu.grapevine.Entities.Event;
import cs.lmu.grapevine.EventFeedArrayAdapter;
import cs.lmu.grapevine.R;

/**
 * Listener for successful EventFeedRequests.
 */
public class EventSuccessListener implements Response.Listener<JSONArray> {
    private Activity parentActivity;
    private Gson     gson = new GsonBuilder().setDateFormat("MM/dd/yyyy").create();

    public EventSuccessListener(Activity parentActivity) {
        this.parentActivity = parentActivity;
    }

    @Override
    public void onResponse(JSONArray response) {
        ListView eventFeed = (ListView)parentActivity.findViewById(R.id.event_feed);
        InflateEventFeed(deserializeJson(response));
    }

    private ArrayList<Event> deserializeJson(JSONArray userEventsJSON) {
        ArrayList<Event> usersEvents = gson.fromJson(userEventsJSON.toString(), new TypeToken<List<Event>>() {
        }.getType());

        return usersEvents;
    }

    private void InflateEventFeed(ArrayList eventList) {
        //if eventList.size == 0, print message
        EventFeedArrayAdapter eventAdapter = new EventFeedArrayAdapter(parentActivity, eventList);
        ListView eventFeed = (ListView) parentActivity.findViewById(R.id.event_feed);
        eventFeed.setAdapter(eventAdapter);

    }

}