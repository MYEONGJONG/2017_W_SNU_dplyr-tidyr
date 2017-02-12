#################################################################################################
###                                                                                           ###
### writer : MYEONGJONG KANG (Seoul National University, SNU)                                 ###
### E-mail : kmj.stat@gmail.com                                                               ###
###                                                                                           ###
### Description : This is for the special course on "Big Data" of SNU-SRI.                    ### 
###               This concentrates on "Data Wrangling" with R package "dplyr" and "tidyr".   ###
###                                                                                           ###
### Reference : Jaimie (Jaimyoung) Kwon's github (and lecture note)                           ###
###                                                                                           ###
#################################################################################################

#################################################################################################
##########                                    dplyr                                    ##########
#################################################################################################

# Flights that Departed NYC in 2013
library(nycflights13)

help(package="nycflights13")

# 데이터를 transpose 취해서 보여준다. 즉, 각 설명변수(열)들이 어떤 값들이 나왔는지 순서대로 보여주는 것이다.
# 이것을 이용하면 데이터프레임 안에 있는 모든 열들을 콘솔에서 편하게 볼 수 있다.
# str 과 다른 점은 콘솔 상에서 가능한 최대한의 값들을 보여준다.
glimpse(flights)
str(flights)

# 연습문제 12/43
glimpse(airlines)
glimpse(airports)
glimpse(planes)
glimpse(weather)

flights
print(flights)

class(flights)

# x <- data.frame(c(1,1))
# class(x)
# class(tbl_df(x))

################################# 고급 연습문제(13/43) #################################

head(as.data.frame(flights))


##################################### 1. filter() #####################################
# 설명 : 주어진 조건을 만족하는 행들을 추려낸다.
# 기초적인 사용법 : filter(주어진 자료(데이터프레임), 필터링하고자 하는 조건) 

# 1월 1일에 출발한 항공편 자료를 찾는 명령
filter(flights, month == 1, day == 1)
filter(flights, month == 1 & day == 1)

# 1월과 2월에 출발한 항공편 자료를 찾는 명령
filter(flights, month == 1 | month == 2)

### slice() : 행을 행 번호로 추려낸다. 
# flights[1:10,] ==
slice(flights, 1:10)


##################################### 2. arrange() #####################################
# 설명 : 행을 변수들의 오름차순으로 정렬한다. 즉 지정한 열을 기준으로 가장 작은 값에서 시작하여
#        가장 큰 값으로 끝나는 순서대로 데이터를 정렬한다.
# 기초적인 사용법 : arrange(주어진 자료(데이터프레임), 오름차순으로 정렬하고자 하는 열(기준))

# flights 자료를 year, month, day 순으로 정렬하는 명령
# flights[order(flights$year, flights$month, flights$day),] ==
arrange(flights, year, month, day)

### desc() : 내림차순으로 정렬하도록 바꾸는 함수이다. 
# arr_delay가 가장 큰 것부터 정렬하는 명령
arrange(flights, desc(arr_delay))


##################################### 3. select() #####################################
# 설명 : 필요한 열을 선택한다. 열 이름을 써주는 연산이 가장 흔히 쓰인다.
# 기초적인 사용법 : select(주어진 자료(데이터프레임), 추출하고자 하는 열의 이름들)

# year, month, day라는 이름을 가진 열을 추출하는 명령
select(flights, year, month, day)

# 열의 범위를 지정하여 열을 추출하는 명령
select(flights, year:arr_time)

# year, month, day라는 이름을 가진 열을 제외하고 나머지를 추출하는 명령
select(flights, -year, -month, -day)

# 열의 범위를 지정하여 그 열들을 제외한 나머지 열들을 추출하는 명령
select(flights, -(year:arr_time))

### + starts_with() : 정해진 문자열로 시작하는 열들을 모두 지정할 때 사용
# arr로 시작하는 이름을 가진 열들을 모두 제외하는 명령
select(flights, -starts_with("arr"))

### + ends_with() : 정해진 문자열로 끝나는 열들을 모두 지정할 때 사용
# delay로 시작하는 이름을 가진 열들을 모두 추출하는 명령
select(flights, ends_with("delay"))

### + matches() : 정해진 형식으로 구성된 이름을 가진 열들을 모두 지정할 때 사용
# 무엇_무엇 꼴의 이름을 가진 열들을 모두 추출하는 명령
select(flights, matches("._."))
select(flights, matches(".r_t."))

### + contains() : 정해진 문자열이 포함된 이름을 가진 열들을 모두 지정할 때 사용
# _이 들어가는 이름을 가진 열들을 모두 추출하는 명령
select(flights, contains("_"))
select(flights, contains("_."))

## ?select 로 추가적으로 확인할 수 있다.

### rename() : 열의 이름을 바꿔준다.
rename(flights, tail_num = tailnum)


##################################### 4. mutate() #####################################
# 설명 : 기존의 열(들)의 값을 이용해 새로운 열을 추가한다. 
#        함수에서 생성한 열을 바로 사용할 수 있다.
# 기초적인 사용법 : mutate(주어진 자료(데이터프레임), 생성하고자 하는 열 계산)

mutate(flights, gain = arr_delay - dep_delay, gain_per_hour = gain / (air_time / 60), speed = distance / air_time * 60)

# transform() 함수와 비교하면?
mutate(flights, gain = arr_delay - dep_delay, gain_per_hour = gain / (air_time / 60))
transform(flights, gain = arr_delay - dep_delay, gain_per_hour = gain / (air_time / 60)) #error


##################################### 5. summarize() #####################################
# 설명 : 주어진 자료(데이터프레임)을 한 줄(행)으로 요약한다. 즉 요약통계량을 계산한다.
#        summarise() 함수도 같은 역할을 한다.
# 기초적인 사용법 : summarize(주어진 자료(데이터프레임), 원하는 요약통계량)

# dep_delay의 평균을 계산하는 명령
summarize(flights, delay = mean(dep_delay, na.rm = TRUE))

# 요약통계함수를 사용한다. 요약통계함수는 벡터값을 입력으로 받아 하나의 숫자를 출력한다.
# 기본 R 패키지의 요약통계함수는 min(), max(), mean(), sum(), sd(), median(), IQR() 등이 있다.
# dplyr 패키지에서 제공하는 요약통계함수는 n(), n_distinct(), first(), last(), nth() 이 있다.
# group_by() 함수와 함께 이용하면 매우 편리하다.


############################## 6. sample_n(), sample_frac() ##############################
# 설명 : sample_n() 함수는 정해진 숫자의 열을 랜덤샘플한다.
#        sample_frac() 함수는 정해진 비율의 열을 랜덤샘플한다.
# 기초적인 사용법 : sample_n(주어진 자료(데이터프레임), 추출하고자 하는 열의 개수)
#                   sample_frac(주어진 자료(데이터프레임), 
#                               추출하고자 하는 열의 개수의 전체 열의 개수에 대한 비율)

# 10줄의 열을 랜덤샘플하는 명령
sample_n(flights, 10)

# 1%의 열을 랜덤샘플하는 명령
sample_frac(flights, 0.01)

# 비복원추출이 default이지만 replace 옵션으로 복원추출할 수도 있다. 
# weight 옵션으로 가중치를 정할 수 있다.
# 재현가능한 연구를 위해서는 set.seed해줄 수 있다.


##################################### 7. distinct() #####################################
# 설명 : 주어진 자료에서 고유한 행을 찾아낸다.
# 기초적인 사용법 : distinct(주어진 자료(데이터프레임) 혹은 자료에서 선택한 열)

# 서로 다른 기체번호를 찾는 명령
distinct(select(flights, tailnum))

# 서로 다른 노선을 찾는 명령
distinct(select(flights, origin, dest))


############################# Language of data manipulation #############################
# (1) 행정렬 arrange()
# (2) 행선택 filter()
# (3) 열선택 select()
# (4) 새로운 변수 계산 mutate()
# (5) 요약통계량 계산 summarise()


########################### group_by() 함수를 이용한 그룹연산  ###########################
# 설명 : 데이터셋을 그룹으로 나눈다.
# 기초적인 사용법 : group_by(주어진 자료(데이터프레임), 그룹으로 나누고자 하는 기준이 되는 열(들))

flights
groups(flights)

(by_tailnum = group_by(flights, tailnum))
groups(by_tailnum)

### 연동사용법

## select() 는 그룹변수를 항상 포함한다.
select(by_tailnum, year, month, day)

## arrange() 는 그룹변수로 우선 정렬한다.
arrange(by_tailnum, day)
arrange(flights, day)

## mutate() 와 filter()는 윈도우 함수(window function)과 더불어 사용한다.
# vignette("window-functions")

# 각 비행기 별로 가장 큰 air_time을 가진 항공편을 추출하는 명령
filter(by_tailnum, min_rank(desc(air_time)) == 1)

# 각 비행기 별로 air_time의 크기를 작은 순서대로 순위화하는 명령
mutate(by_tailnum, rank = min_rank(air_time))

## sample_n() 과 sample_frac() 은 그룹별로 랜덤샘플한다.
sample_n(by_tailnum, 1)

## slice() 는 각 그룹별로 행을 추출한다. 
#slice는 그룹별 원소의 개수보다 많이 숫자를 설정하면 개수만큼 나온다.
slice(by_tailnum, 5)

# summarise() 는 각 그룹별로 요약통계량을 계산한다.
# 아래 참고

#(by_tailnum = group_by(flights, tailnum))
delay = summarise(by_tailnum,
                  count = n(),
                  dist = mean(distance, na.rm = TRUE),
                  delay = mean(arr_delay, na.rm = TRUE))
delay = filter(delay, count > 20, dist < 2000)
delay

### exercise 26/43
groups(by_tailnum)
by_tailnum = ungroup(by_tailnum)
groups(by_tailnum)

### exercise 26/43
rowwise(by_tailnum)
delay = summarise(rowwise(by_tailnum),
                  count = n(),
                  dist = mean(distance, na.rm = TRUE),
                  delay = mean(arr_delay, na.rm = TRUE))
delay = filter(delay, dist < 2000)
delay


########################### ggplot2 패키지를 이용한 시각화 ###########################

by_tailnum = group_by(flights, tailnum)
delay = summarise(by_tailnum,
                  count = n(),
                  dist = mean(distance, na.rm = TRUE),
                  delay = mean(arr_delay, na.rm = TRUE))
delay = filter(delay, count > 20, dist < 2000)
delay

ggplot(delay, aes(dist, delay)) +
  geom_point(aes(size = count), alpha = 1/2) +
  geom_smooth() +
  scale_size_area()

sum(select(delay, count)>=1000)
sum(is.na(select(delay, delay)))


########################### %>% 연산자와 체이닝(chaining) ###########################
# The downside of the functional nature of dplyr is that when you combine multiple data manipulation 
# operations, you have to read from the inside out and the arguments may be very distant to the function 
# call. These functions providing an alternative way of calling dplyr (and other data manipulation) 
# functions that you read can from left to right. (dyplyr 패키지 설명의 chain 부분)

# 임시변수 방법
a1 = group_by(flights, year, month, day)
a2 = select(a1, arr_delay, dep_delay)
a3 = summarise(a2,
               arr = mean(arr_delay, na.rm = TRUE),
               dep = mean(dep_delay, na.rm = TRUE))
(a4 = filter(a3, arr > 30 | dep > 30))

# 중첩 방법
filter(
  summarise(
    select(
      group_by(flights, year, month, day),
      arr_delay, dep_delay
    ),
    arr = mean(arr_delay, na.rm = TRUE),
    dep = mean(dep_delay, na.rm = TRUE)
    ),
  arr > 30 | dep > 30
)

# 두 방법 모두 가독성이 떨어진다. 

### %>% 연산자

# simple1
head(iris)
iris %>% head

# simple2
head(iris, 10)
iris %>% head(10)

# 위의 임시변수 방법과 중첩 방법과 결과가 같다.
# 또한 가독성이 좋다. 
flights %>% 
  group_by(year, month, day) %>%
  select(arr_delay, dep_delay) %>%
  summarise(
    arr = mean(arr_delay, na.rm = TRUE),
    dep = mean(dep_delay, na.rm = TRUE)
  ) %>%
  filter(arr > 30 | dep > 30)


################################## 연습문제(31/43) ##################################

# 날짜 형식을 다루는 패키지
library(lubridate)

# C 언어 중에서 지역화를 지정하는 기능. 
# 구체적으로는 setlocale 함수나 localconv 함수로 통화(通貨)의 표현, 
# 10진수 표현(소수 점이 점인가 콤마인가 등), 일시(日時) 표현의 차이 등 각국 특유의 표현을 지정한다.
# [네이버 지식백과] 로컬 [locale] (컴퓨터인터넷IT용어대사전, 2011. 1. 20., 일진사)
Sys.setlocale("LC_TIME", "usa")

(per_day = flights %>%
  group_by(year, month, day) %>%
  summarise(flights = n(),
            distance = mean(distance),
            arr = mean(arr_delay, na.rm = TRUE),
            dep = mean(dep_delay, na.rm = TRUE)
  ) %>%
  mutate(dt_str = sprintf("%04d-%02d-%02d", year, month, day),
         dt = parse_date_time(dt_str, "ymd",tz = "US/Eastern"),
         dow = wday(dt, label=TRUE)
         ) 
)

# 각각의 도착지에 대해 비행기 개수
flights %>% group_by(tailnum, dest) %>% distinct() %>% group_by(dest) %>% summarise(count = n())

# 각각의 도착지에 대해 다른 항공편 편수
flights %>% group_by(dest) %>% summarise(count = n())

# 각 날짜별 비행기 편수
select(per_day, year:flights)
flights %>% group_by(year,month, day) %>% summarise(count = n())

# 각 요일별 비행기 편수
ungroup(per_day) %>% group_by(dow) %>% summarise(count = sum(flights))
ungroup(per_day) %>% group_by(dow) %>% summarise(count = mean(flights))

per_day %>% ggplot(aes(dt, flights)) +
  geom_line() + geom_point() + geom_smooth()

per_day %>% ggplot(aes(dow, flights)) +
  geom_boxplot()

per_day %>% ggplot(aes(dt, dep)) +
  geom_line() + geom_point() + geom_smooth()

per_day %>% ggplot(aes(dow, dep)) +
  geom_boxplot()

per_day %>% ggplot(aes(dt, distance)) +
  geom_line() + geom_point() + geom_smooth()

per_day %>% ggplot(aes(dow, distance)) +
  geom_boxplot()


########################## join 함수를 이용한 테이블 결합 ##########################

(df1 <- data_frame(x = c(1, 2), y = 2:1))
(df2 <- data_frame(x = c(1, 3), a = 10, b = "a"))

# inner_join() 함수는 x와 y에 모두 매칭되는 행만 포함한다. 교집합이다.
df1 %>% inner_join(df2)

# left_join() 함수는 x 의 모든 행을 포함한다. 매칭되지 않은 y 테이블 변수들을 NA가 된다. 차집합이다.
df1 %>% left_join(df2)

# right_join() 함수는 y 테이블의 모든 행을 포함한다. 
# left_join(y,x) 의 경우와 행의 순서만 다를 뿐 동일한 결과를 준다.
df1 %>% right_join(df2)

# full_join() 함수는 x와 y의 모든 행을 포함한다. 합집합이다.
df1 %>% full_join(df2)


################################## 연습문제(35/43) ##################################

(flights2 = flights %>% select(year:day, hour, origin, dest, tailnum, carrier))
airlines

flights2 %>% left_join(airlines)
# flights2 %>% left_join(airlines, by="carrier")


# rm(list = ls())
################################# 연습문제(37/43)-1 #################################
ds <- tbl_df(mtcars)
ds
as.data.frame(ds)

if (require("Lahman") && packageVersion("Lahman") >= "3.0.1") {
  batting <- tbl_df(Batting)
  dim(batting)
  colnames(batting)
  head(batting)
  
  # Data manipulation verbs ---------------------------------------------------
  filter(batting, yearID > 2005, G > 130)
  select(batting, playerID:lgID)
  arrange(batting, playerID, desc(yearID))
  summarise(batting, G = mean(G), n = n())
  mutate(batting, rbi2 = if(is.null(AB)) 1.0 * R / AB else 0)
  
  # Group by operations -------------------------------------------------------
  # To perform operations by group, create a grouped object with group_by
  players <- group_by(batting, playerID)
  head(group_size(players), 100)
  
  summarise(players, mean_g = mean(G), best_ab = max(AB))
  best_year <- filter(players, AB == max(AB) | G == max(G))
  progress <- mutate(players, cyear = yearID - min(yearID) + 1,
                     rank(desc(AB)), cumsum(AB))
  
  # When you group by multiple level, each summarise peels off one level
  
  per_year <- group_by(batting, playerID, yearID)
  stints <- summarise(per_year, stints = max(stint))
  filter(stints, stints > 3)
  summarise(stints, max(stints))
  mutate(stints, cumsum(stints))
  
  
  # Joins ---------------------------------------------------------------------
  player_info <- select(tbl_df(Master), playerID, birthYear)
  hof <- select(filter(tbl_df(HallOfFame), inducted == "Y"),
                playerID, votedBy, category)
  
  # Match players and their hall of fame data
  inner_join(player_info, hof)
  # Keep all players, match hof data where available
  left_join(player_info, hof)
  # Find only players in hof
  semi_join(player_info, hof)
  # Find players not in hof
  anti_join(player_info, hof)
}


# rm(list = ls())
################################# 연습문제(37/43)-2 #################################

library(babynames)
babynames
class(babynames)

babynames %>% group_by(year) %>% filter(min_rank(desc(n)) == 1)

babynames %>% group_by(year) %>% filter(min_rank(desc(n)) <= 10) %>% summarise(rate = sum(prop))


# rm(list = ls())
################################# 연습문제(37/43)-3 #################################

# 주소로 지정할 수도 있지만...
batting = read.csv(file.choose())
master = read.csv(file.choose())

head(batting)
head(master)

batting = tbl_df(batting)
master = tbl_df(master)

class(batting)
class(master)

# 각 연도별 타자들의 타율을 계산하라. ( AVG(타율) = H(안타) / AB(타수) )

mutate(batting, AVG = H / AB) %>% select(playerID:lgID, AVG)

full.batting = mutate(batting, AVG = H / AB)

# 각 연도별로 선수들의 타율의 분포를 시각화하라.

### plot
full.batting %>% mutate(year = factor(yearID)) %>% 
  group_by(year) %>% 
  ggplot(aes(year, AVG)) + geom_point() + geom_smooth(aes(group=1))

# 자료를 선별하여 분포를 그린 것이므로 참고만 하자.
full.batting %>% mutate(year = factor(yearID)) %>% 
  filter(AB >= 100, yearID >= 1985) %>% 
  group_by(year) %>% 
  ggplot(aes(year, AVG)) + geom_point() + geom_smooth(aes(group=1))

full.batting %>% filter(AB >= 100) %>% 
  group_by(yearID) %>% 
  summarise( n = n()) %>% 
  ggplot(aes(yearID, n))+ geom_point()

### box-plot
full.batting %>% mutate(year = factor(yearID)) %>% 
  group_by(year) %>% 
  ggplot(aes(year, AVG)) + geom_boxplot()

# 자료를 선별하여 분포를 그린 것이므로 참고만 하자.
full.batting %>% mutate(year = factor(yearID)) %>% 
  filter(AB >= 100, yearID >= 1985) %>% 
  group_by(year) %>% 
  ggplot(aes(year, AVG)) + geom_boxplot()


# 1980년 이후 최고타율을 기록한 선수들의 리스트를 구하라. 

(AVGtable = full.batting %>% select(playerID:lgID, AVG))

# min_rank() 함수의 성질
cw <- c(1,2,3,4,NA, 2913)
min_rank(cw)

temp = AVGtable %>% group_by(playerID) %>% filter(min_rank(desc(AVG)) == 1 & yearID >= 1980)

AVGtable %>% filter(playerID == "blackti01")

# 결과 테이블을 Master 테이블과 join 해서 선수의 이름을 표시하라.
(name = master %>% select(playerID, nameFirst, nameLast, nameGiven, retroID, bbrefID))

# select() 순서를 바꾸기 위해 사용해보자.
list = temp %>% left_join(name, by="playerID") %>% select(playerID, nameFirst:bbrefID, yearID:AVG)
list


#################################################################################################
##########                                    tidyr                                    ##########
#################################################################################################

# Key concepts : Long format <-> Wide format, Pivot table

# Core contents : spread() and gather() function

# library(tidyr)


##################################### 1. spread() #####################################
# 설명 : Long format -> Wide format
# 기초적인 사용법 : spread(주어진 자료(데이터프레임), 피벗이 되는 열, 대상이 되는 열)

digest = flights %>% group_by(carrier, origin) %>% 
  summarise(air_time_mean = mean(air_time, na.rm=TRUE))
as.data.frame(digest)

# 피벗 테이블
spread(digest, origin, air_time_mean)

flights %>% group_by(carrier, origin) %>% 
  summarise(air_time_mean = mean(air_time, na.rm=TRUE)) %>%
  spread(origin, air_time_mean)

# NA를 0으로 채우기
spread(digest, origin, air_time_mean, fill = 0)


##################################### 2. gather() #####################################
# 설명 : Wide format -> Long format
# 기초적인 사용법 : gather(주어진 자료(데이터프레임), 변수명을 포함한 열, 대상이 되는 열, 
#                         long format 으로 전환할 열)

series = flights %>% group_by(month, day) %>% 
  summarise(air_time_mean = mean(air_time, na.rm=TRUE), dep_delay_mean = mean(dep_delay, na.rm=TRUE))
series

series %>% gather(indicators, value, air_time_mean, dep_delay_mean)

series %>% gather(indicators, value, -month, -day)

