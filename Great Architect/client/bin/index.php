<!DOCTYPE html>
<html lang="en">
<head>
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js"></script>
	<script type="text/javascript" src="http://connect.facebook.net/en_US/all.js"></script>
	<link href="style.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="fb.js"></script>
</head>
<body>
	<div id="fb-root"></div><!-- required div -->
    <div class="flash">
		<div id="flashContent">
			<h1>You need at least Flash Player 11.3 to view this page.</h1>
			<p><a href="http://www.adobe.com/go/getflashplayer"><img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" /></a></p>
		</div>	
    </div>
	<script type="text/javascript">
		var flashvars = {};
		var params = {};
		params.allowfullscreen = "true";
		params.allowscriptaccess = "always";
		var attributes = {};
		attributes.id = "flashContent";
		attributes.align = "middle";
		
		//swfobject.embedSWF("GreatArchitect.swf", "flashContent", "760", "800", "11.3", null, null, params, {name:"flashContent"});
		swfobject.embedSWF("GreatArchitect.swf?<? echo(time()) ?>", "flashContent", "760", "800", "11.3", null, null, params, {name:"flashContent"});
	</script>
</body>
</html>