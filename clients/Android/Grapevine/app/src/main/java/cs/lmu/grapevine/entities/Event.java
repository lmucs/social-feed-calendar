package cs.lmu.grapevine.entities;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.sql.Date;

/**
 * Represents a database Event entity.
 */
public class Event implements Serializable {
    private String title;
    private Date date;
    private boolean allDay;
    private String status;
    private int id;
    private long timestamp;
    private String location;
    @SerializedName("startTime")
    private long startTimeTimestamp;
    @SerializedName("endTime")
    private long endTimeTimestamp;
    private boolean repeatsWeekly;
    private String[] tags;
    private String URL;
    private String origin;
    private String post;

    private Event(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }

    public  void setTitle(String title) {
        this.title = title;
    }

    public  Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public long getTimeProcessed() {
        return timestamp;
    }

    public void setTimeProcessed(int timeProcessed) {
        this.timestamp = timeProcessed;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public long getStartTimeTimestamp() {
        return startTimeTimestamp;
    }

    public void setStartTimeTimestamp(int startTimeTimestamp) {
        this.startTimeTimestamp = startTimeTimestamp;
    }

    public long getEndTimeTimestamp() {
        return endTimeTimestamp;
    }

    public void setEndTimeTimestamp(int endTimeTimestamp) {
        this.endTimeTimestamp = endTimeTimestamp;
    }

    public boolean isRepeatsWeekly() {
        return repeatsWeekly;
    }

    public void setRepeatsWeekly(boolean repeatsWeekly) {
        this.repeatsWeekly = repeatsWeekly;
    }

    public String[] getTags() {
        return tags;
    }

    public void setTags(String[] tags) {
        this.tags = tags;
    }

    public String getURL() {
        return URL;
    }

    public void setURL(String URL) {
        this.URL = URL;
    }

    public String getPost() {
        return post;
    }

    public void setPost(String post) {
        this.post = post;
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public boolean isAllDay() {
        return allDay;
    }

    public void setAllDay(boolean allDay) {
        this.allDay = allDay;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Event event = (Event) o;

        return id == event.id;
    }

    @Override
    public int hashCode() {
        return id;
    }
}
