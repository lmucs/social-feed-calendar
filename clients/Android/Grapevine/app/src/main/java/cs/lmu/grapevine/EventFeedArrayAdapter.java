package cs.lmu.grapevine;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import cs.lmu.grapevine.Entities.Event;

public class EventFeedArrayAdapter extends ArrayAdapter<Event> {

    public EventFeedArrayAdapter(Context context, ArrayList<Event> events) {
        super(context, 0, events);
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        Event event = getItem(position);

        //courtesy of https://github.com/codepath/android_guides/wiki/Using-an-ArrayAdapter-with-ListView
        // Check if an existing view is being reused, otherwise inflate the view
        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.event_list_view, parent, false);
        }
        TextView eventNameView = (TextView) convertView.findViewById(R.id.event_title);
        TextView eventDateView = (TextView)  convertView.findViewById(R.id.event_date);

        eventNameView.setText(event.getTitle());
        eventDateView.setText(event.getDate().toString());
        return convertView;
    }
}
