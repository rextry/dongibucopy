package kr.spring.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;

@Configuration
@EnableScheduling
@ComponentScan(basePackages = "kr.spring.challenge.scheduler") //스케줄러가 있는 패키지 경로
public class SchedulerConfig {

    //스레드 풀을 가진 스케줄러를 정의
    public ThreadPoolTaskScheduler taskScheduler() {
        ThreadPoolTaskScheduler taskScheduler = new ThreadPoolTaskScheduler();
        taskScheduler.setPoolSize(10); //스레드 풀의 크기 설정
        taskScheduler.setThreadNamePrefix("Scheduler-"); //스레드 이름의 접두사 설정
        taskScheduler.initialize(); //스케줄러 초기화
        return taskScheduler;
    }
}