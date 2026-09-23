package com.example.demo.model;

import java.util.ArrayList;
import java.util.List;

public class QuizQuestion {
    private Integer id;
    private Integer quizId;
    private String content;
    private String type;
    private String optionA;
    private String optionB;
    private String optionC;
    private String optionD;
    private String correctAnswer;
    private Integer score;

    // Getters and Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getQuizId() {
        return quizId;
    }

    public void setQuizId(Integer quizId) {
        this.quizId = quizId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getOptionA() {
        return optionA;
    }

    public void setOptionA(String optionA) {
        this.optionA = optionA;
    }

    public String getOptionB() {
        return optionB;
    }

    public void setOptionB(String optionB) {
        this.optionB = optionB;
    }

    public String getOptionC() {
        return optionC;
    }

    public void setOptionC(String optionC) {
        this.optionC = optionC;
    }

    public String getOptionD() {
        return optionD;
    }

    public void setOptionD(String optionD) {
        this.optionD = optionD;
    }

    public String getCorrectAnswer() {
        return correctAnswer;
    }

    public void setCorrectAnswer(String correctAnswer) {
        this.correctAnswer = correctAnswer;
    }

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
    }
    
    public List<String> getOptionsList() {
        List<String> options = new ArrayList<>();
        if (optionA != null && !optionA.isEmpty()) {
            options.add(optionA);
        }
        if (optionB != null && !optionB.isEmpty()) {
            options.add(optionB);
        }
        if (optionC != null && !optionC.isEmpty()) {
            options.add(optionC);
        }
        if (optionD != null && !optionD.isEmpty()) {
            options.add(optionD);
        }
        return options;
    }
}