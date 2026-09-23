package com.example.demo.model;

import java.util.Date;

public class AttendanceSetting {
    private Integer id;
    private Integer teacherId;
    private Double latitude;
    private Double longitude;
    private Double radius;
    private Integer duration;
    private Integer earlySignMinutes;
    private Integer lateSignMinutes;
    private Boolean enableLocation;
    private Boolean enableFaceRecognition;
    private Date createTime;
    private Date updateTime;

    // Getters and Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(Integer teacherId) {
        this.teacherId = teacherId;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public Double getRadius() {
        return radius;
    }

    public void setRadius(Double radius) {
        this.radius = radius;
    }

    public Integer getDuration() {
        return duration;
    }

    public void setDuration(Integer duration) {
        this.duration = duration;
    }

    public Integer getEarlySignMinutes() {
        return earlySignMinutes;
    }

    public void setEarlySignMinutes(Integer earlySignMinutes) {
        this.earlySignMinutes = earlySignMinutes;
    }

    public Integer getLateSignMinutes() {
        return lateSignMinutes;
    }

    public void setLateSignMinutes(Integer lateSignMinutes) {
        this.lateSignMinutes = lateSignMinutes;
    }

    public Boolean getEnableLocation() {
        return enableLocation;
    }

    public void setEnableLocation(Boolean enableLocation) {
        this.enableLocation = enableLocation;
    }

    public Boolean getEnableFaceRecognition() {
        return enableFaceRecognition;
    }

    public void setEnableFaceRecognition(Boolean enableFaceRecognition) {
        this.enableFaceRecognition = enableFaceRecognition;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }
}