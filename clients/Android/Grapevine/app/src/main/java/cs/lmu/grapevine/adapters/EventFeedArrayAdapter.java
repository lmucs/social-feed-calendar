package cs.lmu.grapevine.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.TextView;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.sql.Date;
import java.util.Calendar;
import java.util.Collections;
import java.util.Locale;
import cs.lmu.grapevine.entities.Event;
import cs.lmu.grapevine.R;
import org.apache.commons.lang3.time.DateUtils;

/**
 * Renders the views for the event feed from an ArrayList of events.
 */
public class EventFeedArrayAdapter extends ArrayAdapter<Event> implements Filterable {
    protected ArrayList<Event> originalEvents;
    protected ArrayList<Event> filteredItems;
    protected TextView eventMonth;
    protected TextView eventDay;
    protected TextView eventTime;
    protected TextView multiDay;
    protected TextView eventTitle;
    protected Date today;

    SimpleDateFormat dateMonth   = new SimpleDateFormat("LLL", Locale.ENGLISH) ;
    SimpleDateFormat dateDay     = new SimpleDateFormat("d",Locale.ENGLISH);
    SimpleDateFormat timeOfEvent = new SimpleDateFormat("h:mm a",Locale.ENGLISH);
    SimpleDateFormat fullDate    = new SimpleDateFormat("M/d/yyyy",Locale.ENGLISH);
    
    public EventFeedArrayAdapter(Context context, ArrayList<Event> events) {
        super(context, 0, events);
        this.originalEvents = new ArrayList<>(events);
        filteredItems = events;
    }

    @Override
    public int getCount() {
        return filteredItems.size();
    }

    public Event getItem(int position) {
        return filteredItems.get(position);
    }

    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View eventFeedView, ViewGroup parent) {
        getTimeNow();
        Event event = filteredItems.get(position);

        if (eventFeedView == null) {
            eventFeedView = LayoutInflater.from(getContext()).inflate(R.layout.event_list_view, parent, false);
        }

        getUIElements(eventFeedView);
        setEventFields(event);

        return eventFeedView;
    }

    @Override
    public Filter getFilter() {

        return new Filter() {
            @Override
            protected FilterResults performFiltering(CharSequence eventDayString) {
                String[] parsePatterns = new String[]{"M/d/yyyy"};

                FilterResults results = new FilterResults();
                ArrayList<Event> filteredEvents = new ArrayList<>();
                java.util.Date selectedDate = null;

                try{
                    selectedDate = DateUtils.parseDate((String)eventDayString,parsePatterns);
                } catch (Exception e) {

                }

                for (Event event : originalEvents){
                    if (event.isOn(selectedDate)) {
                        filteredEvents.add(event);
                    }
                }

                results.values = filteredEvents;
                results.count  = filteredEvents.size();

                return results;
            }

            @Override
            protected void publishResults(CharSequence constraint, FilterResults results) {
                filteredItems = (ArrayList<Event>)results.values;
                notifyDataSetChanged();
            }
        };
    }

    protected void setEventFields(Event event) {
        showMultiDayIfMultiDay(event);
        setTitle(event);

        String startMonth = dateMonth.format(event.getStartDate());
        String startDay   = dateDay.format(event.getStartDate());

        String endMonth = dateMonth.format(event.getEndDate());
        String endDay   = dateDay.format(event.getEndDate());

        String todayMonth = dateMonth.format(today);
        String todayDay   = dateDay.format(today);

        String eventTime;
        if (event.startsLaterToday()) {
            if (event.endTimeIsKnown()) {
                eventTime = "today from "
                                + timeOfEvent.format(event.getStartDate())
                                + " - "
                                + timeOfEvent.format(event.getEndDate());
            } else {
                eventTime = "today at " + timeOfEvent.format(event.getStartDate());
            }
            setCalendarPageAndEventTime(todayMonth, todayDay, eventTime);
        } else if(!(event.endTimeIsKnown())) {
            eventTime = timeOfEvent.format(event.getStartDate());
            setCalendarPageAndEventTime(startMonth, startDay, eventTime);
        } else if (event.startsAndEndsSameDay()) {
            eventTime = timeOfEvent.format(event.getStartDate())
                    + " - "
                    + timeOfEvent.format(event.getEndDate());
            setCalendarPageAndEventTime(startMonth, startDay, eventTime);
        } else if (event.endsLaterToday()) {
            eventTime = "ends today at " + timeOfEvent.format(event.getEndDate());
            setCalendarPageAndEventTime(endMonth, endDay, eventTime);
        } else if(event.getStartDate().after(today)) {
            eventTime = timeOfEvent.format(event.getStartDate());
            setCalendarPageAndEventTime(startMonth, startDay, eventTime);
        } else {
            eventTime = "ends on " + fullDate.format(event.getEndDate());
            setCalendarPageAndEventTime(todayMonth, todayDay, eventTime);
        }
    }

    protected void setCalendarPageAndEventTime(String eventMonth, String eventDay, String eventTime) {

        if (!(this.eventMonth == null)) {
            this.eventMonth.setText(eventMonth);
        }

        if (!(this.eventDay == null)) {
            this.eventDay.setText(eventDay);
        }

        if (!(this.eventTime == null)) {
            this.eventTime.setText(eventTime);
        }

    }

    protected void showMultiDayIfMultiDay(Event event) {
       if (event.isMultiDay()){
            multiDay.setVisibility((View.VISIBLE));
       } else {
           multiDay.setVisibility(View.INVISIBLE);
       }
    }

    protected void getUIElements(View eventFeedView) {
        eventMonth = ((TextView)eventFeedView.findViewById(R.id.event_month));
        eventDay   = ((TextView)eventFeedView.findViewById(R.id.event_day));
        eventTime  = ((TextView)eventFeedView.findViewById(R.id.event_time));
        multiDay   = ((TextView)eventFeedView.findViewById(R.id.multi_day));
        eventTitle = (TextView) eventFeedView.findViewById(R.id.event_title);
    }

    protected void getTimeNow() {
        long nowTimestamp = Calendar.getInstance().getTimeInMillis();
        today = new Date(nowTimestamp);
    }

    protected void setTitle(Event event) {
        if (event.getTitle() == null) {
            eventTitle.setText(R.string.untitled_event_title);
        } else {
            eventTitle.setText(event.getTitle());
        }
    }

    @Override
    public void notifyDataSetChanged() {
        Collections.sort(filteredItems);

        super.notifyDataSetChanged();
    }
}