import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class OuterRing extends WatchUi.Drawable {
    var steps = 7000.0 as Float;
    var font;
    var context = false;

    function initialize() {
        var dictionary = {
            :identifier => "OuterRing"
        };

        Drawable.initialize(dictionary);
    }


    function setContext(dc) {
        var width = dc.getWidth();

        font = width < 300 ? WatchUi.loadResource(Rez.Fonts.JetbrainsNumbers20) : WatchUi.loadResource(Rez.Fonts.JetbrainsNumbers32);
        context = true;
    }

    function getSteps() as Float {
        var info = ActivityMonitor.getInfo();
        var goal = info.stepGoal.toFloat();
        if (info.steps != null && info.steps > 0) {
            steps = info.steps.toFloat();
        } 

        if (goal == null) {
            return steps * 0.02;
        }

        var stepsToGoalRatio = steps / goal;
        if (stepsToGoalRatio >= 1) {
            return 1.0;
        }

        return stepsToGoalRatio;
    }

    function draw(dc as Dc) as Void {
        if (!context) {
            setContext(dc);
        }

        var outerRadius = dc.getWidth() / 2;
        var innerRadius = outerRadius * 0.82;
        var thickness = (outerRadius * 0.13).toNumber();
        var padding = (thickness / 2).toNumber();
        if (dc.getWidth() < 300) {
            padding = padding * 2;
        }
        var arcStart = 180 - padding;
        var arcLength = 360;

        var stepPercent = getSteps();
        if (stepPercent < 1.0) {
            arcLength = (360 * stepPercent).toNumber();

            if (arcLength < 50) {
                arcLength = 50;
            }
        }

        dc.setAntiAlias(true);
        dc.setPenWidth(thickness);
        if (stepPercent >= 1.0) {
            dc.setColor(Application.Properties.getValue("TenderGreen"), Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(Application.Properties.getValue("DeepBlue"), Graphics.COLOR_TRANSPARENT);
        }
        dc.drawArc(outerRadius, outerRadius, innerRadius - thickness, Graphics.ARC_CLOCKWISE, arcStart - padding, arcStart - arcLength);
        dc.fillCircle(outerRadius + (Math.cos((arcStart + 3 * padding) * 0.0174533)) * (innerRadius - thickness - 1), outerRadius + Math.sin((arcStart + 3 * padding) * 0.0174533) * (innerRadius - thickness - 1), thickness / 2 - 1);
        dc.fillCircle(outerRadius + (Math.cos((arcStart + 2 * padding + arcLength) * 0.0174533)) * (innerRadius - thickness - 1), outerRadius + Math.sin((arcStart + 2 * padding + arcLength) * 0.0174533) * (innerRadius - thickness - 1), thickness / 2 - 1);


        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        
        //Draw text
        for (var i = 0; i < steps.format("%d").length(); ++i) {
            var symbol = steps.format("%d").substring(i, i + 1);
            var offset = padding / 2 + (padding * (i + 1)) / 2.25;
            var x = outerRadius + Math.cos((arcStart + 3 * padding + offset) * 0.0174533) * (innerRadius - thickness / 2 + 1);
            var y = outerRadius + Math.sin((arcStart + 3 * padding + offset) * 0.0174533) * (innerRadius - thickness / 2 + 1);
            dc.drawText(x, y, font, symbol, Graphics.TEXT_JUSTIFY_LEFT);
        }
    }

}
