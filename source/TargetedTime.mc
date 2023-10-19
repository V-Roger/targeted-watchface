import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class Time extends WatchUi.Drawable {
    var bgFont;
    var font;
    var yOffset;
    var bgYOffset;
    var padding;
    var context = false;

    function initialize() {
        var dictionary = {
            :identifier => "Time"
        };

        Drawable.initialize(dictionary);
    }

    function setContext(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();

        padding = width / 25;
        bgFont = width < 300 ? WatchUi.loadResource(Rez.Fonts.RubikNumbers82) : WatchUi.loadResource(Rez.Fonts.RubikNumbers142);
        font = width < 300 ? WatchUi.loadResource(Rez.Fonts.RubikNumbers72) : WatchUi.loadResource(Rez.Fonts.RubikNumbers132);
        yOffset = width < 300 ? height / 2 - 36 : height / 2 - 66;
        bgYOffset = width < 300 ? height / 2 - 38 : height / 2 - 68;

        context = true;
    }

    function draw(dc as Dc) as Void {
        // Get the current time and format it correctly
        var clockTime = System.getClockTime();
        var settings = System.getDeviceSettings();

        var hours = clockTime.hour;
        if (!settings.is24Hour) {
            if (hours >= 12) {
                hours = hours - 12;
            }
            if (hours == 0) {
                hours = 12;
            }
        }
        var mins = clockTime.min.format("%02d");

        var x = dc.getWidth() / 2;
        var y = dc.getHeight() / 2;
        

        if (!context) {
            setContext(dc);
        }

        dc.setAntiAlias(true);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x - padding + 5,
            y,
            bgFont,
            hours.format("%02d"),
            Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        
        dc.drawText(
            x + padding - 5,
            y,
            bgFont,
            mins,
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            x - padding,
            y,
            font,
            hours.format("%02d"),
            Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER
        );
        
        dc.drawText(
            x + padding,
            y,
            font,
            mins,
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

}
