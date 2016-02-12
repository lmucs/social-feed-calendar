package cs.lmu.grapevine.requests.listeners.success;

import android.app.Activity;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import com.android.volley.Response;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import org.json.JSONArray;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import cs.lmu.grapevine.activities.EventFeed;
import cs.lmu.grapevine.activities.Login;
import cs.lmu.grapevine.entities.Event;
import cs.lmu.grapevine.adapters.EventFeedArrayAdapter;
import cs.lmu.grapevine.R;

/**
 * Listener for successful EventFeedRequests.
 */
public class EventSuccessListener implements Response.Listener<JSONArray> {
    private Activity parentActivity;


    public EventSuccessListener(Activity parentActivity) {
        this.parentActivity = parentActivity;
    }

    @Override
    public void onResponse(JSONArray response) {
        ArrayList<Event> usersEvents = deserializeJson(response);
        EventFeed.usersEvents = usersEvents;
        Collections.sort(EventFeed.usersEvents);
        InflateEventFeed(usersEvents);
        Login.lastRefresh = new Date().getTime();
        clearLoadingMessage();
    }

    public static ArrayList<Event> deserializeJson(JSONArray userEventsJSON) {
        Gson gson = new GsonBuilder().setDateFormat("MM/dd/yyyy").create();
        ArrayList<Event> usersEvents = gson.fromJson(userEventsJSON.toString(), new TypeToken<List<Event>>() {
        }.getType());

        return usersEvents;
    }

    private void InflateEventFeed(ArrayList eventList) {
        if (eventList.size() == 0) {
            printEmptyListMessage();
        }
        EventFeedArrayAdapter eventAdapter = new EventFeedArrayAdapter(parentActivity, eventList);
        ListView eventFeed = (ListView) parentActivity.findViewById(R.id.event_feed);
        eventFeed.setAdapter(eventAdapter);
        EventFeed.usersEventsAdapter = eventAdapter;
    }

    private void printEmptyListMessage() {
        TextView emptyMessageContainer = (TextView) parentActivity.findViewById(R.id.empty_message);
        emptyMessageContainer.setVisibility(View.VISIBLE);
    }

    private void clearLoadingMessage() {
        LinearLayout welcomeMessage = (LinearLayout)parentActivity.findViewById(R.id.loading);
        welcomeMessage.setVisibility(View.GONE);
        parentActivity.findViewById(R.id.upcoming).setVisibility(View.VISIBLE);
        parentActivity.findViewById(R.id.miActionProgress).setVisibility(View.GONE);
    }
}