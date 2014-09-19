#ggplot2 backstage tour

https://www.youtube.com/watch?v=RHu5vgBZ1yQ

candidates <- c( Sys.getenv("R_PROFILE"),file.path(Sys.getenv("R_HOME"), "etc", "Rprofile.site"),Sys.getenv("R_PROFILE_USER"),file.path(getwd(), ".Rprofile") )

Filter(file.exists, candidates)
