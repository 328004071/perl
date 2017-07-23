#RScript
library(gplots);
library(ROCR);
#　作者：施梦军（Shi Mengjun）
#  单位：安徽大学
#曲线IN
table <-read.table("QUEPASA_ROC_QUEPASA_file", header = TRUE, sep = "\t");
pre <- prediction(table$score,table$label);
pref <- performance(pre,"tpr","fpr");


#jpeg("3ss_0.05_4_ROC_SP.jpeg");
#pdf("3ss_0.05_4_ROC_SP.pdf");
bmp("ESE_ESS_QUEPASA_ROC_SP.bmp");
#png("3ss_0.05_4_ROC_SP.png");

plot(pref, col = "red",lty = 1);
#, print.cutoffs.at = seq(-1,1,by = 0.5)
auc1 = performance(pre,"auc")@y.values;
print(auc1);
auc1 = sprintf("%.3f",auc1);
#曲线SP
table <-read.table("QUEPASA_sp_ROC_QUEPASA_file", header = TRUE, sep = "\t");
prep <- prediction(table$score,table$label);
prefp <- performance(prep,"tpr","fpr");
plot(prefp, col = "green",add = TRUE,lty =2);
auc2 = performance(prep,"auc")@y.values;
print(auc2);
auc2 = sprintf("%.3f",auc2);

#曲线WMM
#table <-read.table("3ss-WMM_ROC_file", header = TRUE, sep = "\t");
#pre <- prediction(table$score,table$label);
#pref <- performance(pre,"tpr","fpr");
#plot(pref, add = TRUE,col = "blue", lty = 3);
#auc3 = performance(pre,"auc")@y.values;
#print(auc3);
#auc3 = sprintf("%.3f",auc3);

#曲线MM
#table <-read.table("3ss-MM_ROC_file", header = TRUE, sep = "\t");
#pre <- prediction(table$score,table$label);
#pref <- performance(pre,"tpr","fpr");
#plot(pref, add = TRUE,col = "black", lty = 4);
#auc4 = performance(pre,"auc")@y.values;
#print(auc4);
#auc4 = sprintf("%.3f",auc4);

#legend("bottomright", c(paste("MEMS=",auc1),paste("SP=",auc2),paste("SF=",auc3)),lty = c(1,2,5), col = c("red","green","blue"));
legend("bottomright", c(paste("QUEPASA=",auc1),paste("SP=",auc2)),lty = c(1,2), col = c("red","green"));

dev.off()


#cutoff曲线
#auc = performance(prep, "auc")
#auc = unlist(auc@y.values)
#print(auc)
#if (FALSE){

acc = performance(prep, "acc")

ac.val = max(unlist(acc@y.values))
print(ac.val)
th = unlist(acc@x.values)[unlist(acc@y.values) == ac.val]
print(th)#最优cutoff点

plot(acc)
abline(v=th, col='grey', lty=2)

#}
