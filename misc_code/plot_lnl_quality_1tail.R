events = read.csv("results/detected_events_1tail.csv")
events$StartDate = as.character(events$StartDate)
events$EndDate = as.character(events$EndDate)

addEvents = function(s, ylm){
	for(i in 1:nrow(events)){
		event_start = -1
		event_end = -1
		for(j in 1:nrow(s)){
			
			if(events$StartDate[i]==s$date[j] && events$StartHour[i]==s$hour[j])
				event_start = j
			if(events$EndDate[i]==s$date[j] && events$EndHour[i]==s$hour[j])
				event_end = j
			
		}
		
		if(event_start>0 && event_end>0){
			
			polygon(x=c(event_start, event_end, event_end, event_start), y=c(ylm[1], ylm[1], ylm[2], ylm[2]), col=rgb(.5,.5,.5,.4))
		}
	
	}

}




svg("results/lnl_quality_1tail.svg", 12, 8)
par(mfrow=c(2,1), mar=c(3,3,2,1))

#lnl plot
t = read.csv("results/lnl_over_time_1tail.csv")
t$date = as.character(t$date)
s = t[t$date>="2012-10-21" & t$date<="2012-11-11",]

plot(s$lnl_norm, col="black", type="l", main="Log-Likelihood Event Detection", xaxt="n", xlab="", ylab="Log-Likelihood")
ids = (0:20) * 24 + 1
weekdays = rep(c("Su","M","Tu","W","Th","F","Sa"),3)
axis(1,at=ids, labels= weekdays)
abline(v=ids)
ids2 = (0:3)*24*7 + 1
abline(v=ids2, lwd=2)
lines(s$lnl_smooth, col="blue", lwd=3)

thresh = quantile(t$lnl_norm, .2)
abline(h=thresh, col="red", lwd=2, lty=1)



#lines(s$lnl_lognorm, col="purple", type="l", xaxt="n", xlab="", ylab="Log-Likelihood")
#ids = (0:21) * 24 + 1
#axis(1, at=ids, labels=s$date[ids], las=3, cex.axis=.7)
#lines(s$lnl_lognorm_smooth, col="darkgreen", lwd=2)



addEvents(s, range(s$lnl_norm))

legend("bottomright", legend=c("LnL", "LnL Smoothed", "Threshold (.05 Quant)"), col=c("black", "blue", "red"),
	lwd=c(1,2,2), bg="white")



#pace plot
t = read.csv("results/quality_1tail.csv")
t$date = as.character(t$Date)
t$hour = t$Hour
s = t[t$date>="2012-10-21" & t$date<="2012-11-11",]

plot(0,0, type="n", main="Pace Comparison", xaxt="n", xlab="", ylab="Pace (sec/mi)", xlim=c(1,nrow(s)), ylim=c(100,500), lwd=2)


for(i in 1:(nrow(s)-1)){
	if(s$PaceObs[i] < s$PaceAvg[i]){
		mycol = "green"
	}
	else{
		mycol = "red"
	}
	
	polygon(x=c(i, i+1, i+1, i), y=c(s$PaceAvg[i], s$PaceAvg[i+1], s$PaceObs[i+1], s$PaceObs[i]), col=mycol, border=mycol)
}


lines(s$PaceObs, col="black", lwd=2)
lines(s$PaceAvg, col="blue", lwd=2)
lines(s$PaceMin, col="red", lwd=2)
ids = (0:20) * 24 + 1
#axis(1, at=ids, labels=s$date[ids], las=3, cex.axis=.7)
axis(1, at=ids, labels=weekdays)
abline(v=ids)
ids2 = (0:3)*24*7 + 1
abline(v=ids2, lwd=3)
lines(s$lnl_smooth, col="blue", lwd=2)



addEvents(s, c(100,500))

legend("topright", legend=c("ObsPace", "AvgPace", "MinPace"), col=c("black", "blue", "red"), lwd=2, bg="white")




#quality curve

#plot(0,0,type="n", xlim=c(1,nrow(s)), ylim=c(min(s$QObs), 1), main="Quality Curve", xlab="", ylab="Quality", xaxt="n")

#for(i in 1:(nrow(s)-1)){
#	if(s$QObs[i] > s$QAvg[i]){
#		mycol = "green"
#	}
#	else{
#		mycol = "red"
#	}
#	
#	polygon(x=c(i, i+1, i+1, i), y=c(s$QAvg[i], s$QAvg[i+1], s$QObs[i+1], s$QObs[i]), col=mycol, border=mycol)
#}



#lines(s$QObs, col="black", type="l", xaxt="n", xlab="", ylab="Pace (sec/mi)", lwd=2)
#lines(s$QAvg, col="blue", lwd=2)
#abline(h=1, lwd=2, col="red")
#ids = (0:21) * 24 + 1
#axis(1, at=ids, labels=s$date[ids], las=3, cex.axis=.7)


#addEvents(s, c(min(s$QObs), 1))

#legend("bottomright", legend=c("ObsQ", "AvgQ", "MaxQ"), col=c("black", "blue", "red"), lwd=2)


dev.off()
