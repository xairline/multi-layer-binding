# Honeycomb Bravo Only
## 1. Initial Installation
### 1.1 Binding Layer Switch Keys
In your xplane's joystick configuration, bind layer up/down btn to anything you like. I used trim wheel and trim B (on alpha)
![image](https://github.com/user-attachments/assets/97618897-ecf1-42c9-b012-5c964cfef9a7)

### 1.2 Binding Bravo Keys
Similar to above, you need to bind key 20-33 to these
![image](https://github.com/user-attachments/assets/58583676-897b-498a-9b1a-efcb4f41447c)

Note:
20 & 21: Button 1
22 & 22: Button 2
....
32 && 33: Button 7
![image](https://github.com/user-attachments/assets/5c02c166-0684-4401-833e-c4f1b93f7896)

## 2. Add Layers and Btn mapping
There is a csv file for zibo 737 provided as an example:

![image](https://github.com/user-attachments/assets/e0c46065-b623-4a6f-a508-cf5aff653d74)

you can define as many layers as you want and each layer can have up to 7 btns. The command is what xplane will do when you click on that btn when you are on that layer.

There is an advanced btn definition for CRS Feed:
```
laminar/B738/fuel/cross_feed_valve:1?laminar/B738/toggle_switch/crossfeed_valve_on:laminar/B738/toggle_switch/crossfeed_valve_off
```
This means when `laminar/B738/fuel/cross_feed_valve` is **lese than** 1, click that btn will trigger `laminar/B738/toggle_switch/crossfeed_valve_on` otherwise it will trigger `laminar/B738/toggle_switch/crossfeed_valve_off`. This is to let a btn change it's behaviour based on a dataref. 

This is needed cause when you switch layers, a btn might not be in the "on" position so we need to use dataref to know what should be on/off. In other cases, a simple cmd is provided because that cmd is "toggle". For the CRS Feed, there is no toggle cmd but on and off so we have to determine the current state to simulate "toggle"