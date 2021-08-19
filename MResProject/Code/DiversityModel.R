library(minpack.lm)

ReadData = function(type){ # Taxon/Function
    data = paste(type,"_HillDiversity.txt",sep="")
    HillDiversity = read.table(data,sep="\t",header=TRUE)
    return(HillDiversity)
} 

# Functions for multimodel inference
RSS = function(x, y, predic_y){
  # Sum of squares
  # x: independent variable values
  # y: dependent variable values
  # predic_y: predicted dependent variable values
  Rss = sum((y-predic_y)^2)
  return(Rss)}
likelihood = function(x, y, predic_y){
  # Likelihood
  # x: independent variable values
  # y: dependent variable values
  # predic_y: predicted dependent variable values
  Rss = RSS(x,y,predic_y)
  n = length(x)
  L = -0.5*n*log(Rss/n)
  return(L)}
AICc = function(x, y, predic_y, k){
  # corrected Akaike information criterion (AICc)
  # x: independent variable values
  # y: dependent variable values
  # predic_y: predicted dependent variable values
  # k: number of coefficients
  L = likelihood(x,y,predic_y)
  n = length(x)
  AICc = -2*L+2*k+2*k*(k+1)/(n-k-1)
  return(AICc)}
AIC_weight = function(vector){
  # Akaike weight
  # vector: AIC values
  detaAIC = vector-min(vector,na.rm=TRUE)
  weight = exp(-0.5*detaAIC)/sum(exp(-0.5*detaAIC),na.rm=TRUE)
  return(weight)}

# Candidate species accumulation models:
model1 = function(x,a,b){return( a*x/(b*x+1) )}
model2 = function(x,a,b){return( a*(1-exp(-b*x)) )}
model3 = function(x,a,b,c){return( a-b*c^x )}
model4 = function(x,a,b,c){return( a*(1-exp(-b*x))^c )}
model5 = function(x,a,b,c,d){return( a*(1-(1+(x/c)^d)^-b) )}

# Derivations of candidate models
d_model1 = function(x,a,b){return( a/((b*x+1)^2) )}
d_model2 = function(x,a,b){return( a*b*exp(-b*x) )}
d_model3 = function(x,a,b,c){return( -b*c^(x)*log(c) )}
d_model4 = function(x,a,b,c){return( a*b*c*exp(-b*x)*(1-exp(-b*x))^(c-1) )}
d_model5 = function(x,a,b,c,d){return( (a*b*d/c)*((x/c)^(d-1))*(1+(x/c)^d)^(-b-1) )}

ModelFitting = function(x,y,type){
  # Function for model fitting, model averaging
  # Estimate the point where curve slope drops to cut-off values
  # INPUT:
  # x: independent variable vector
  # y: dependent variable vector 
  
  # Model fitting 
  m1 = try(
    nlsLM(y ~ model1(x,a,b),
          start = list(a=max(y),b=1),
          lower = c(0,0), upper = c(Inf,1),control=list(maxiter=200)),silent = TRUE
  )
  if (as.vector(summary(m1))[2] != "try-error"){
    m1_results = as.numeric(c(coef(summary(m1))["a",1],coef(summary(m1))["b",1],NA))
    m1_predict = model1(x,m1_results[1],m1_results[2])
    m1_results[3] = AICc(x,y,m1_predict,2)
    m1 = function(n){
      return( model1(x=n,a=m1_results[1],b=m1_results[2]) )
    }
    d_m1 = function(n){
      return( d_model1(x=n,a=m1_results[1],b=m1_results[2]) )
    }
  }else{
    m1_results=c(NA,NA,NA)
    model1 = 0
  }
  
  m2 = try(
    nlsLM(y ~ model2(x,a,b),
          start = list(a=max(y),b=0.05),
          lower = c(0,0), upper = c(Inf,Inf),control=list(maxiter=200)),silent = TRUE
  )
  if (as.vector(summary(m2))[2] != "try-error"){
    m2_results = as.numeric(c(coef(summary(m2))["a",1],coef(summary(m2))["b",1],NA))
    m2_predict = model2(x,m2_results[1],m2_results[2])
    m2_results[3] = AICc(x,y,m2_predict,2)
    m2 = function(n){
      return( model2(x=n,a=m2_results[1],b=m2_results[2]) )
    }
    d_m2 = function(n){
      return( d_model2(x=n,a=m2_results[1],b=m2_results[2]) )
    }
  }else{
    m2_results=c(NA,NA,NA)
    model2 = 0
  }
  
  m3 = try(
    nlsLM(y~model3(x,a,b,c),
          start = list(a=max(y),b=1e+12,c=0.5),
          lower = c(0,0,0),upper = c(Inf,Inf,1),control=list(maxiter=200)),silent = TRUE
  )
  if (as.vector(summary(m3))[2] != "try-error"){
    m3_results = as.numeric(c(coef(summary(m3))["a",1],coef(summary(m3))["b",1],coef(summary(m3))["c",1],NA))
    m3_predict = model3(x,m3_results[1],m3_results[2],m3_results[3])
    m3_results[4] = AICc(x,y,m3_predict,3)
    m3 = function(n){
      return( model3(x=n,a=m3_results[1],b=m3_results[2],c=m3_results[3]) )
    }
    d_m3 = function(n){
      return( d_model3(x=n,a=m3_results[1],b=m3_results[2],c=m3_results[3]) )
    }
  }else{
    m3_results=c(NA,NA,NA,NA)
    model3 = 0
  }
  
  m4 = try(
    nlsLM(y~model4(x,a,b,c),
          start = list(a=max(y),b=0.02,c=0.5),
          lower = c(0,0,0),upper=c(Inf,Inf,1),control=list(maxiter=200)),silent=TRUE
  )
  if (as.vector(summary(m4))[2] != "try-error"){
    m4_results = as.numeric(c(coef(summary(m4))["a",1],coef(summary(m4))["b",1],coef(summary(m4))["c",1],NA))
    m4_predict = model4(x,m4_results[1],m4_results[2],m4_results[3])
    m4_results[4] = AICc(x,y,m4_predict,3)
    m4 = function(n){
      return( model4(x=n,a=m4_results[1],b=m4_results[2],c=m4_results[3]) )
    }
    d_m4 = function(n){
      return( d_model4(x=n,a=m4_results[1],b=m4_results[2],c=m4_results[3]) )
    }
  }else{
    m4_results=c(NA,NA,NA,NA)
    model4 = 0
  }
  
  m5 = try(
    nlsLM(y~model5(x,a,b,c,d),
          start = list(a=max(y),b=1.5,c=10,d=0.5),
          lower = c(0,0,0,0),upper=c(Inf,Inf,Inf,1),control=list(maxiter=200)),silent=TRUE
  )
  if (as.vector(summary(m5))[2] != "try-error"){
    m5_results = as.numeric(c(coef(summary(m5))["a",1],coef(summary(m5))["b",1],coef(summary(m5))["c",1],coef(summary(m5))["d",1],NA))
    m5_predict = model5(x,m5_results[1],m5_results[2],m5_results[3],m5_results[4])
    m5_results[5] = AICc(x,y,m5_predict,4)
    m5 = function(n){
      return( model5(x=n,a=m5_results[1],b=m5_results[2],c=m5_results[3],d=m5_results[4]) )
    }
    d_m5 = function(n){
      return( d_model5(x=n,a=m5_results[1],b=m5_results[2],c=m5_results[3],d=m5_results[4]) )
    }
  }else{
    m5_results=c(NA,NA,NA,NA,NA)
    model5 = 0
  }
  
  # Compute weight
  AICc_values = c(m1_results[length(m1_results)],
                  m2_results[length(m2_results)],
                  m3_results[length(m3_results)],
                  m4_results[length(m4_results)],
                  m5_results[length(m5_results)])
  weight = AIC_weight(AICc_values)
  weight[is.na(weight)] = 0
  
  # Compute asymptote
  asymptotes = c(m1_results[1]/m1_results[2],
                 m2_results[1],
                 m3_results[1],
                 m4_results[1],
                 m5_results[1])
  asymptotes[is.na(asymptotes)]=0
  Asymptote = sum(asymptotes*weight)
  
  # Average model
  AverageModel = function(N){
    y = 0
    for (i in 1:5){
      if (weight[i] != 0){
        y = y + weight[i]*get(paste("m",as.character(i),sep=""))(N)
      }
    }
    return(y)
  }
  
  # derivation of average model
  d_AverageModel = function(N){
    y = 0
    for (i in 1:5){
      if (weight[i] != 0){
        y = y + weight[i]*get(paste("d_m",as.character(i),sep=""))(N)
      }
    }
    return(y)
  }
  
  simu_x = seq(0.01, max(x), 0.01)
  simu_y = AverageModel(simu_x)
  d_simu_y = d_AverageModel(simu_x)
  
  Est = function(threshold){
    i = 0.01
    while (d_AverageModel(i)>threshold){i=i+0.01}
    ret = list(OptDepth=i,OptDiversity=AverageModel(i))
    return(ret)
  }

  if (type=="Taxon"){
  est_0.5 = Est(0.5)
  est_0.1 = Est(0.1)
  est_0.05 = Est(0.05)
  est_0.01 = Est(0.01)
  }
  if (type=="Function"){
  est_0.5 = Est(50)
  est_0.1 = Est(10)
  est_0.05 = Est(5)
  est_0.01 = Est(1)
  }
  
  ret = list(
    x=x,y=y, # original data points
    simu_x=simu_x,simu_y=simu_y, # fitted curve
    d_simu_y=d_simu_y, # slope
    Asymptote=Asymptote, # asymptote
    OptDepth_0.5=est_0.5$OptDepth,OptDiversity_0.5=est_0.5$OptDiversity, # point where slope drops to 0.5
    OptDepth_0.1=est_0.1$OptDepth,OptDiversity_0.1=est_0.1$OptDiversity, # point where slope drops to 0.1
    OptDepth_0.05=est_0.05$OptDepth,OptDiversity_0.05=est_0.05$OptDiversity, # point where slope drops to 0.05
    OptDepth_0.01=est_0.01$OptDepth,OptDiversity_0.01=est_0.01$OptDiversity, # point where slope drops to 0.01
    m1=m1_results,m2=m2_results,m3=m3_results,m4=m4_results,m5=m5_results, # fitted coefficients
    weight=weight)# Akaike weight)
    
    return(ret)
}


run_ModelFitting = function(sample,q,type){
  HillDiversity = ReadData(type)
  data = subset(HillDiversity,HillDiversity$Sample==sample)
  x = data$CleanRead * data$SubsamplePercent / 1e+6
  y = data[,paste("Hill_",q,sep="")]
  M = ModelFitting(x,y,type)
  return(M)
}