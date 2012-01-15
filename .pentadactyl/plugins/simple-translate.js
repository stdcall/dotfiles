/* AUTHOR:  Maksim Ryzhikov
 * NAME:    simple-translate(beautiful-translate)
 * VERSION: 2.0
 * URL: https://github.com/maksimr
 */
//INFORMATION {{{
var INFO =
<plugin name="simple-translate" version="2.0"
    href="https://github.com/maksimr/beautiful-translate"
    summary="simple-translate allwo you translate text using google translator"
    xmlns={NS}>
    <author email="rv.maksim@gmail.com">Ryzhikov Maksim</author>
    <license href="http://opensource.org/licenses/mit-license.php">MIT License</license>
    <project name="Pentadactyl" minVersion="1.0"/>
    <p>
			This plugin allow you translate text from command line using google translator
			you can also use the options "Allow the writing of Latin".
			Languages support this option: 
			Russian[ru], Arabic[ar], Greek[el], Persian[fa], Serbian[sr], Urdu[ur], Hindi[hi]
    </p>
    <p>
			To determine the translation languages you can use optional arguments -langpair|-L 
			or define in your .pentadactylrc 'set langpair="en|ru"'.
			For using opton "Allow the writing of Latin" you must define in
			your .pentadactylrc 'set conv="ru"' and in command line use arguments -conv|-C
    </p>
</plugin>;
//}}}

var Cc = Components.classes,
Ci = Components.interfaces,
Translator = function () {};

var icon = 'data:image/png;base64,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\
fQf4H4a4VnuN4RvlAAAAAElFTkSuQmCC';

/*
 * @in translate mode
 */
Translator.prototype.langpair = "en|ru";
/*
 * @in notification
 */
Translator.prototype.notification = Cc['@mozilla.org/alerts-service;1'].getService(Ci.nsIAlertsService);
/*
 * @in convert mode
 */
Translator.prototype.conv = "ru";
Translator.prototype.count = "5";
/**
 * @param {array} query
 * @param {string} langpair
 * @returns {XMLHttpRequest}
 */
Translator.prototype.translate = function (query, langpair) {
	return util.httpGet("http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=" + encodeURIComponent(query.join(" ")) + "&langpair=" + encodeURIComponent(langpair || this.langpair), {
		callback: function (response) {
      var text = JSON.parse(response.responseText).responseData.translatedText;
      this.notification.showAlertNotification(icon, "Translation", text, false, '', null);
      dactyl.echomsg(text);
		}.bind(this)
	});
};
/**
 * @param {object} context
 * @param {array} args
 * @returns {XMLHttpRequest}
 */
Translator.prototype.converter = function (context, args) {
	var uri = 'http://www.google.com/transliterate?tlqt=1&langpair=' + encodeURIComponent("en|" + this.conv) + '&text=' + encodeURIComponent(args.pop()) + '%2C&tl_app=8&num=' + (this.count || 5) + '&version=3';
	return util.httpGet(uri,{
		callback: function (response) {
			var txt = JSON.parse(response.responseText.replace(/,[\n]*(?=\]|\}|,)/g, ''))[0];
			var text = (txt.hws) ? txt.hws[0] : " ";
			var match = txt.ew;
			context.filter = text;
			context.completions = [[t, "converted text"] for each (t in txt.hws)];
		}
	},this);
};
var tr = new Translator();

group.commands.add(["translate", "tr"], "Google Translator", function (args) {
  if (args['-conv']||args['-C'] && !(args['-langpair'] || args['-L'])){
    args['-langpair'] = tr.langpair.replace(/([a-z]{2})\|([a-z]{2})/i,'$2|$1');
  }
	tr.translate(args, args['-langpair'] || args['-L']);
},
{
	argCount: "2",
	completer: function (context, args) {
		if (args['-conv'] || args['-C']) {
			tr.converter(context, args);
		}
	},
	options: [{
		names: ['-langpair', '-L'],
		description: "To determine translation languages",
		type: commands.OPTION_STRING
	},
	{
		names: ['-conv', '-C'],
		description: "Allow the writing of Latin"
	}]
});
group.options.add(["langpair", "lang"], "Determine translation languages", "string", "en|ru", {
	setter: function (value) {
		Translator.prototype.langpair = value;
		return value;
	}
});
group.options.add(["conv", "cnv"], "Define languages for writing of Latin", "string", "ru", {
	setter: function (value) {
		Translator.prototype.conv = value;
		return value;
	}
});
// vim: set fdm=marker sw=2 ts=2 sts=2 et:
