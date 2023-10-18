import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class Center extends WatchUi.Drawable {

  function initialize() {
    var dictionary = {
      :identifier => "Center"
    };

    Drawable.initialize(dictionary);
  }

  function getStressLvl() {
    var sample = 0.0;
    var value = "";

    if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getStressHistory)) {
      sample = SensorHistory.getStressHistory({:period => 1})
        .next();
      if (sample != null && sample.data != null) {
        value = sample.data;
      }
    }

    return value.toNumber();
  }

  function draw(dc as Dc) as Void {
    var outerRadius = dc.getWidth() / 2;
    var innerRadius = outerRadius * 0.52;
    var thickness = (outerRadius * 0.12).toNumber();
    var padding = (thickness / 1.5).toNumber();

    var batteryLvl = Math.floor(System.getSystemStats().battery);
    var batteryColor = Application.Properties.getValue("TenderGreen");

    if (batteryLvl < 25) {
      batteryColor = Application.Properties.getValue("WarmRed");
    } else if (batteryLvl < 50) {
      batteryColor = Application.Properties.getValue("GoldenYellow");
    } else if (batteryLvl < 75) {
      batteryColor = Application.Properties.getValue("DeepBlue");
    }

    var stressLvl = getStressLvl();
    var stressColor = Application.Properties.getValue("TenderGreen");

    if (stressLvl > 75) {
      stressColor = Application.Properties.getValue("WarmRed");
    } else if (stressLvl > 50) {
      stressColor = Application.Properties.getValue("EdgyPurple");
    }

    dc.setColor(stressColor, Graphics.COLOR_BLACK);

    dc.fillCircle(outerRadius, outerRadius, (innerRadius - padding * 2) - (innerRadius - padding * 4) * stressLvl / 100);
    dc.setClip(outerRadius - innerRadius, outerRadius - padding / 2, innerRadius * 2, innerRadius + padding / 2);
    dc.clear();

    dc.setClip(outerRadius - innerRadius, outerRadius + padding / 2, innerRadius * 2, innerRadius - padding / 2);
    dc.setColor(batteryColor, Graphics.COLOR_BLACK);
    dc.fillCircle(outerRadius, outerRadius, (innerRadius - padding * 2) * batteryLvl / 100);

    dc.clearClip();
  }
}