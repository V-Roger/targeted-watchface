import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class InnerRing extends WatchUi.Drawable {
    var context = false;
    var font;

    function initialize() {
        var dictionary = {
            :identifier => "InnerRing"
        };

        Drawable.initialize(dictionary);
    }

    function setContext(dc) {
        var width = dc.getWidth();

        font = width < 300 ? WatchUi.loadResource(Rez.Fonts.JetbrainsNumbers20) : WatchUi.loadResource(Rez.Fonts.JetbrainsNumbers32);
        context = true;
    }

    function getHeartRate() {
        var activityInfo = Activity.getActivityInfo();
        var sample = activityInfo.currentHeartRate;
        var value = 1.0;
        if (sample != null) {
            value = sample;
        } else if (ActivityMonitor has :getHeartRateHistory) {
          sample = ActivityMonitor.getHeartRateHistory(1, /* newestFirst */ true)
            .next();
            if ((sample != null) && (sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE)) {
                value = sample.heartRate;
            }
        }

        return value;
    }

    function getHeartRateZone() {
        var zones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);
        var sample = getHeartRate();

        if (sample < zones[0]) {
            return 0;
        } else if (sample < zones[1]) {
            return 1;
        } else if (sample < zones[2]) {
            return 2;
        } else if (sample < zones[3]) {
            return 3;
        }
        return 4;
    }

    function draw(dc as Dc) as Void {   
        if (!context) {
            setContext(dc);
        }

        var outerRadius = dc.getWidth() / 2;
        var innerRadius = outerRadius * 0.63;
        var thickness = (outerRadius * 0.13).toNumber();
        var padding = (thickness / 1.5).toNumber();
        if (dc.getWidth() < 300) {
            padding = padding * 2;
        }
        var arcStart = 180 - padding;
        var zones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);

        var colors = [
            Application.Properties.getValue("TenderGreen"),
            Application.Properties.getValue("DeepBlue"),
            Application.Properties.getValue("GoldenYellow"),
            Application.Properties.getValue("WarmRed"),
            Application.Properties.getValue("EdgyPurple"),
        ];

        var zone = getHeartRateZone();
        var heartRate = getHeartRate();
        
        var arcLength = 360 - (270 * (heartRate.toFloat() / zones[5].toFloat())).toNumber();

        dc.setAntiAlias(true);
        dc.setPenWidth(thickness);
        dc.setColor(colors[zone], Graphics.COLOR_TRANSPARENT);
        dc.drawArc(outerRadius, outerRadius, innerRadius - thickness, Graphics.ARC_CLOCKWISE, arcStart - padding, arcStart - arcLength);
        dc.fillCircle(outerRadius + (Math.cos((arcStart + 3 * padding) * 0.0174533)) * (innerRadius - thickness - 1), outerRadius + Math.sin((arcStart + 3 * padding) * 0.0174533) * (innerRadius - thickness - 1), thickness / 2);
        dc.fillCircle(outerRadius + (Math.cos((arcStart + 2 * padding + arcLength) * 0.0174533)) * (innerRadius - thickness - 1), outerRadius + Math.sin((arcStart + 2 * padding + arcLength) * 0.0174533) * (innerRadius - thickness), thickness / 2);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        //Draw text
        for (var i = 0; i < heartRate.format("%d").length(); ++i) {
            var symbol = heartRate.format("%d").substring(i, i + 1);
            var offset = padding / 2 + (padding * (i + 1)) / 2.25;
            var x = outerRadius + Math.cos((arcStart + 3 * padding + offset) * 0.0174533) * (innerRadius - thickness / 2 + 1);
            var y = outerRadius + Math.sin((arcStart + 3 * padding + offset) * 0.0174533) * (innerRadius - thickness / 2 + 1);
            dc.drawText(x, y, font, symbol, Graphics.TEXT_JUSTIFY_LEFT);
        }
    }

}
