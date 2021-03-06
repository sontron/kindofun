#' ggpltS
#' 
#' a wrapper function based on ggplot for easy plot. used in shiny app.
#' 
#' 
#' @export


ggpltS<-function(data,
                 x,
                 y='NULL',
                 size='NULL',
                 fill='NULL',
                 color='NULL',
                 shape='NULL',
                 alpha='NULL',
                 facetVar='NULL',
                 geom=c('box','hist','bar','line','jitter','point','smooth')[1],
                 labx='x',
                 laby='y',
                 title='my Plot',
                 theme=c('grey','bw','classic','dark')[1],
                 smoothMethod=c('lm','glm','loess','gam')[1],
                 barPos=c('stack','dodge')[1],
                 Bins=2,
                 # Colour='NULL',
                 # Fill='NULL',
                 # Size='NULL',
                 # Alpha=.5,
                 Width=.5,
                 ...
                 
                 
){
  
  geom=unlist(stri_split_fixed(geom,';'))
  facetVar=unlist(stri_split_fixed(facetVar,';'))
  if(is.character(data)) data=eval(as.name(data))
  
  
  
  
  myGeom<-function(geom,...){
    switch(geom,
           box=geom_boxplot(...,width=Width),
           hist=geom_histogram(...,aes(y=..density..),bins = Bins),
           bar=geom_bar(...,aes(y=..count..),position=barPos,width=Width),
           line=geom_line(...),
           jitter=geom_jitter(...),
           point=geom_point(...),
           smooth=geom_smooth(...,method=smoothMethod)
           
    )
  }
  
  
  P<-"ggplot(data=data,aes_string(x=x,y=y,size=size,fill=fill,color=color,shape=shape,alpha=alpha))"
  
  geoms<-paste(paste('myGeom(',paste("'",geom,"'",sep=''),')',sep=''),collapse='+')
  #names(sapply(geom,function(i)myGeom(i)))->geoms
  
  paste(P,geoms,sep='+')->graph
  if(!is.null(facetVar)&facetVar!='NULL'){
    paste('facet_wrap(~',paste(facetVar,collapse='+'),')',sep='')->facet
    paste(graph,facet,sep='+')->graph
  }
  
  myTheme<-function(theme){
    switch(theme,
           bw=theme_bw(),
           grey=theme_grey(),
           dark=theme_dark(),
           classic=theme_classic()
    )
  }
  
  themes<-paste("myTheme(",paste("'",theme,"'",sep=''),")",sep='')
  
  myLab<-paste("labs(",paste("x=labx","y=laby","title=title",sep=','),")",sep='')
  
  adjTitle<-'theme(plot.title=element_text(hjust=.5))'
  
  paste(graph,themes,myLab,adjTitle,sep='+')->Graph
  resGGplot<-eval(parse(text=Graph))
  ggplotly(resGGplot)->resPlotly
  return(list(resGGplot=resGGplot,resPlotly=resPlotly))
  
  
}





#' ggplt2S
#' 
#' use ggplot2S!
#' 
#' @param data  data.frame
#' 
#' @param x x vars.
#' 
#' @param y  y vars, could be NULL
#' 
#' @param size  variable mapping to size aes.
#' 
#' @param fill variable mapping to fill aes.
#' 
#' @param color variable mapping to color aes.
#' 
#' @param shape variable mapping to shape aes.
#' 
#' @param alpha variable mapping to alpha aes.
#' 
#' @param facetVar  variables used in faceting.
#' 
#' @param geom  geoms for ploting, eg: geom=c('point','smooth')
#' 
#' @param smoothMethod smoothing method used in a smooth line.
#' 
#' @param theme could be "grey","bw","classic","dark",etc.
#' 
#' @param labx  x lable.
#' 
#' @param laby y lable.
#' 
#' @param title  plot title.
#' 
#' @param barPos used when geom including "bar",could be "stack","dodge".
#' 
#' @param Bins numeric value to set binwidth in a histogram plot.
#' 
#' @param Colour setting colour, eg:Colour='red'
#' 
#' @param Fill setting Fill colour.
#' 
#' @param Size setting size of point, line,etc.
#' 
#' @param Alpha setting transparency.
#' 
#' @param Width setting width of barplot or boxplot.
#' 
#' @param Shape  setting shape.
#' 
#' 
#' @return resGGplot  ggplot.
#' 
#' @return resPlotly  plot that's generated with ggplotly.
#' 
#' @examples 
#' ggplt2S(data=mtcars,x='mpg',y='disp',size='wt',geom=c('point','smooth'),smoothMethod='lm',theme='bw',title='my plot')
#' 
#' @export


ggplt2S<-function(data,
                  x,
                  y='NULL',
                  size='NULL',
                  fill='NULL',
                  color='NULL',
                  shape='NULL',
                  alpha='NULL',
                  facetVar='NULL',
                  geom=c('box','hist','bar','line','jitter','point','smooth')[1],
                  labx='x',
                  laby='y',
                  title='my Plot',
                  theme=c('grey','bw','classic','dark')[1],
                  smoothMethod=c('lm','glm','loess','gam')[1],
                  barPos=c('stack','dodge')[1],
                  Bins='NULL',
                  Colour='NULL',
                  Fill='NULL',
                  Size='NULL',
                  Alpha='NULL',
                  Width='NULL',
                  Shape='NULL'
                  
                  
){
  
  
  if(is.character(data)) data=eval(as.name(data))
  geom=unlist(stri_split_fixed(geom,';'))
  facetVar=unlist(stri_split_fixed(facetVar,';'))
  if(is.character(data)) data=eval(as.name(data))
  
  
  
  
  myGeom<-function(Bins,Colour,Size,Fill,Alpha,Width,Shape,geom){
    switch(geom,
           box=paste('geom_boxplot(',paste(ifelse(Fill%in%c('NULL',NA,''),'','fill=Fill,'),
                                           ifelse(Width%in%c('NULL',NA,''),'','width=Width,'),
                                           ifelse(Alpha%in%c('NULL',NA,''),'','alpha=Alpha'),
                                           collapse=''
           ),')',sep=''),
           
           
           hist=paste('geom_histogram(aes(y=..density..),',paste(ifelse(Fill%in%c('NULL',NA,''),'','fill=Fill,'),
                                                                 ifelse(Bins%in%c('NULL',NA,''),'','bins=Bins,'),
                                                                 ifelse(Alpha%in%c('NULL',NA,''),'','alpha=Alpha,'),
                                                                 ifelse(Colour%in%c('NULL',NA,''),'','color=Colour'),
                                                                 collapse=''
           ),')',sep=''),
           
           
           bar=paste('geom_bar(aes(y=..count..),',paste(ifelse(Fill%in%c('NULL',NA,''),'','fill=Fill,'),
                                                        ifelse(Width%in%c('NULL',NA,''),'','width=Width,'),
                                                        ifelse(Alpha%in%c('NULL',NA,''),'','alpha=Alpha,'),
                                                        'position=barPos',
                                                        collapse=''
           ),')',sep=''),
           
           
           line=paste('geom_line(',paste(ifelse(Colour%in%c('NULL',NA,''),'','color=Colour'),
                                         collapse=''
           ),')',sep=''),
           
           
           jitter=paste('geom_jitter(',paste(ifelse(Colour%in%c('NULL',NA,''),'','color=Colour,'),
                                             ifelse(Alpha%in%c('NULL',NA,''),'','alpha=Alpha'),
                                             collapse=''
           ),')',sep=''),
           
           
           point=paste('geom_point(',paste(ifelse(Colour%in%c('NULL',NA,''),'','color=Colour,'),
                                           ifelse(Shape%in%c('NULL',NA,''),'','shape=Shape,'),
                                           ifelse(Size%in%c('NULL',NA,''),'','size=Size,'),
                                           ifelse(Alpha%in%c('NULL',NA,''),'','alpha=Alpha'),
                                           collapse=''
           ),')',sep=''),
           
           
           smooth=paste('geom_smooth(method=smoothMethod,',paste(ifelse(Colour%in%c('NULL',NA,''),'','color=Colour,'),
                                                                 collapse=''
           ),')',sep='')
    )->Geom
    stri_replace_all_regex(Geom,'(,\\)|, \\))',')')->Geom
    # return(Geom)
    return(eval(parse(text=Geom)))
    
  }
  
  
  P<-"ggplot(data=data,aes_string(x=x,y=y,size=size,fill=fill,color=color,shape=shape,alpha=alpha))"
  
  geoms<-paste(paste('myGeom(Bins=Bins,Colour=Colour,Fill=Fill,Size=Size,Alpha=Alpha,Width=Width,Shape=Shape,',paste("'",geom,"'",sep=''),')',sep=''),collapse='+')
  
  paste(P,geoms,sep='+')->graph
  if(!is.null(facetVar)&facetVar!='NULL'){
    paste('facet_wrap(~',paste(facetVar,collapse='+'),')',sep='')->facet
    paste(graph,facet,sep='+')->graph
  }
  
  myTheme<-function(theme){
    switch(theme,
           bw=theme_bw(),
           grey=theme_grey(),
           dark=theme_dark(),
           classic=theme_classic()
    )
  }
  
  themes<-paste("myTheme(",paste("'",theme,"'",sep=''),")",sep='')
  
  myLab<-paste("labs(",paste("x=labx","y=laby","title=title",sep=','),")",sep='')
  
  adjTitle<-'theme(plot.title=element_text(hjust=.5))'
  
  paste(graph,themes,myLab,adjTitle,sep='+')->Graph
  resGGplot<-eval(parse(text=Graph))
  tryCatch(ggplotly(resGGplot),error=function(e)NULL)->resPlotly
  return(list(resGGplot=resGGplot,resPlotly=resPlotly))
  
  
}

