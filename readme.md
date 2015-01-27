# Stalker : A wicked follower story

Study project from artificial intelligence initiation course

### INSTALL DEPENDENCIES

```bash
$ bundle install
```

### RUN

```bash
$ cd src
$ bundle exec ruby app.rb
```
Once app running, go to ```localhost:4567``` in your favorite browser

### DEFAULT PARAMETERS

All parameters can be set in your browser, but if you don't, default parameters are set

- size : 50 * 50
- there is one idol
- population of stalkers : 3
- number of walls : 50

### STRATEGIES
You can make your idol flee in 3 differents ways, all using vectors and polars coordinates to choose the next move:
-  1  No special capability over other ones
-  2  Idol never choses the last square as destination
-  3  Idol never comes too close of walls (1 space between idol and walls)

### LAUNCH SIMULATION

You can enter your parameters in the dedicated form and click ```Run !```

Stop/Restart the simulation by using 'S' key

### SCREENSHOTS
#### Stalkers don't move because of the walled idol
![Stalkers don't move because of the walled idol](http://snag.gy/5RwF4.jpg)
----------------------------------------------------------------------------

#### Moore neighbourhood movement is so unfair for idol
![Moore neighbourhood movement is so unfair for idol](http://snag.gy/Tx9JO.jpg)
-------------------------------------------------------------------------------

#### Von Neumann neighbourhood movement is much better for idol
![Von Neumann neighbourhood movement is much better](http://snag.gy/iIyFJ.jpg)
