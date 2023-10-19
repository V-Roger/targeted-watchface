import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class MoveBar extends WatchUi.Drawable {
    function initialize() {
        var dictionary = {
            :identifier => "MoveBar"
        };

        Drawable.initialize(dictionary);
    }

    function draw(dc as Dc) as Void {
        var outerRadius = dc.getWidth() / 2;
        var thickness = (outerRadius * 0.13).toNumber();
        var innerRadius = outerRadius;
        var max = ActivityMonitor.MOVE_BAR_LEVEL_MAX;
        var arcStart = 180;
        var arcLength = 360;
        var arcIncrement = (360 / max).toNumber();
        var padding = (thickness / 2).toNumber();
        if (dc.getWidth() < 300) {
            padding = padding * 2;
        }
        var colors = [
            Application.Properties.getValue("BrightBlue"),
            Application.Properties.getValue("DeepBlue"),
            Application.Properties.getValue("EdgyPurple"),
            Application.Properties.getValue("GoldenYellow"),
            Application.Properties.getValue("WarmRed"),
        ];

        var info = ActivityMonitor.getInfo();
        var moveLvl = info.moveBarLevel;
        
        dc.setAntiAlias(true);
        dc.setPenWidth(thickness);

        if (moveLvl == null) {
            dc.setColor(Application.Properties.getValue("TenderGreen"), Graphics.COLOR_TRANSPARENT);
            dc.drawArc(outerRadius, outerRadius, outerRadius - thickness, Graphics.ARC_CLOCKWISE, arcStart, arcStart - arcLength);
            dc.fillCircle(outerRadius + (Math.cos((arcStart) * 0.0174533)) * (innerRadius - thickness), outerRadius + Math.sin((arcStart)  * 0.0174533) * (innerRadius - thickness), thickness / 2 - 1);
            dc.fillCircle(outerRadius + (Math.cos((arcStart + arcLength) * 0.0174533)) * (innerRadius - thickness), outerRadius + Math.sin((arcStart + arcLength) * 0.0174533) * (innerRadius - thickness), thickness / 2 - 1);
            return;
        }

        arcLength = arcLength - moveLvl * arcIncrement;

        if (moveLvl != 5) {
            dc.setColor(Application.Properties.getValue("TenderGreen"), Graphics.COLOR_TRANSPARENT);
            dc.drawArc(outerRadius, outerRadius, outerRadius - thickness, Graphics.ARC_CLOCKWISE, arcStart - padding, arcStart - arcLength);
            dc.fillCircle(outerRadius + (Math.cos((arcStart + padding) * 0.0174533)) * (innerRadius - thickness), outerRadius + Math.sin((arcStart + padding)  * 0.0174533) * (innerRadius - thickness), thickness / 2 - 1);
            dc.fillCircle(outerRadius + (Math.cos((arcStart + arcLength) * 0.0174533)) * (innerRadius - thickness), outerRadius + Math.sin((arcStart + arcLength) * 0.0174533) * (innerRadius - thickness), thickness / 2 - 1);
        }
        
        var i = 0;
        while (i < max && i < moveLvl) {
            dc.setColor(colors[i], Graphics.COLOR_TRANSPARENT);
            dc.drawArc(outerRadius, outerRadius, outerRadius - thickness, Graphics.ARC_CLOCKWISE, arcStart - (max - i - 1) * arcIncrement - padding, arcStart - (max - i) * arcIncrement);
            dc.fillCircle(outerRadius + (Math.cos((arcStart - (i) * arcIncrement) * 0.0174533)) * (innerRadius - thickness), outerRadius + Math.sin((arcStart - (i) * arcIncrement)  * 0.0174533) * (innerRadius - thickness), thickness / 2 - 1);
            dc.fillCircle(outerRadius + (Math.cos((arcStart - (i + 1) * arcIncrement + padding) * 0.0174533)) * (innerRadius - thickness), outerRadius + Math.sin((arcStart - (i + 1) * arcIncrement + padding) * 0.0174533) * (innerRadius - thickness), thickness / 2 - 1);
            i++;
        }

        if (moveLvl == 5) {

            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
            
            var label = "MOVE";
            //Draw text
            for (var j = 0; j < label.length(); ++j) {
                var symbol = label.substring(j, j + 1);
                var offset = padding / 2 + (padding * (j + 1)) / 2.25;
                var x = outerRadius + Math.cos((arcStart + padding + offset) * 0.0174533) * (innerRadius - thickness / 2);
                var y = outerRadius + Math.sin((arcStart + padding + offset) * 0.0174533) * (innerRadius - thickness / 2);
                dc.drawText(x, y, Graphics.FONT_XTINY, symbol, Graphics.TEXT_JUSTIFY_LEFT);
            }

        }
    }

}
