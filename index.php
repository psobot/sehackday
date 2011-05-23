<!DOCTYPE html>
<html>
	<head>
		<title>SE Hack Day</title>
		<!-- SE Hack Day temp site, @psobot, May 22, 2011 -->
		<meta name="description" content='A day to hack, learn, build, teach, share and create.' />
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />

		<meta property="og:title" content="SE Hack Day" />
		<meta property="og:type" content="non_profit" />
		<meta property="og:url" content="http://www.sehackday.com/" />
		<meta property="og:image" content="http://www.sehackday.com/img/fb-thumb.png" />
		<meta property="og:description" content="A day to hack, learn, build, teach, share and create." />

		<link rel="shortcut icon" type="image/png" href="img/icon.png" />
		<link rel="image_src" type="image/png" href="http://www.sehackday.com/img/fb-thumb.png" />
		<link href='http://fonts.googleapis.com/css?family=Arimo:regular,italic,bold&subset=latin' rel='stylesheet' type='text/css' />
		<style type="text/css">
			body {
				font-family: 'Arimo', 'Helvetica', 'Arial', sans-serif;
				font-size: 18px;
				font-style: normal;
				font-weight: normal;
				text-shadow: none;
				text-decoration: none;
				text-transform: none;
				letter-spacing: -0.05em;
				word-spacing: 0em;
				line-height: 1;
				text-align: center;
				color: #eee;
				padding-top: 20px;
				background: #0c0017;
			}
			a {
				color: #fff;
				text-decoration: none;
			}
			a:hover {
				text-decoration: underline;
			}
			h1 {
				font-size: 4em;
				margin: 0;
			}

			#subhead {
				font-size: 20px;
			}
			#subhead p {
				margin: 0;
			}

			#is {
				width: 580px;
				margin: 30px auto;
				text-align: center;
				font-size: 25px;
			}
			
			body > .title {
				position: relative;
				width: 580px;
				margin: 30px auto;
				text-align: left;
			}
			body > .title .number{
				font-size: 40px;
				position: absolute;
				text-align: right;
				left: -60px;
			}
			.line { margin: 20px auto; border-bottom: 1px solid #ccc; width: 580px; }
			.smaller {
				text-align: center;
				margin-top: 10px;
				font-size: 18px;
			}

			.container {
				background: #eee;
				color: #0c0017;
				border-radius: 10px;
				-webkit-border-radius: 10px;
				--moz-border-radius: 10px;
				-o-border-radius: 10px;
				width: 580px;
				margin: 10px auto 30px;
				text-align: left;
				padding: 5px 0;
			}
			.hack {
				height: 94px;
				padding: 5px 10px;
				border-top: 1px solid #ccc;
			}
			.hack:first-child {
				border-top: none;
			}
			.hack .title {
				padding-top: 12px;
			}
			.hack a {
				color: #888;
			}
			.hack .image {
				float: left;
				margin: 0 10px 5px 0;
			}
			.hack .description {
				color: #999;
				margin: 10px;
			}
			#footer {
				text-align: center;
				opacity: 0.4;
				color: #888;
				border-top: 1px solid #ccc;
				padding: 20px;
			}
			.next {
				padding: 5px 10px;
			}

		</style>
		<script type="text/javascript">

		  var _gaq = _gaq || [];
		  _gaq.push(['_setAccount', 'UA-6427057-17']);
		  _gaq.push(['_trackPageview']);

		  (function() {
			var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
			ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
			var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
		  })();

		</script>
	</head>
	<body>
		<h1><img src="img/logo-white.png" title="SE HACK DAY" alt="SE HACK DAY" /></h1>
		<div id="subhead">
			<p>
				<a href="http://twitter.com/search/%23sehackday" target="_blank" >#sehackday on twitter</a> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
				<a href="mailto:sehackday@petersobot.com">contact SE Hack Day</a>
			</p>
		</div>
		<div id="is">
			<p>
				Come <strong>hack</strong>, <strong>learn</strong>, <strong>build</strong>, <strong>teach</strong>, <strong>share</strong> and <strong>create</strong>.<br />
			</p>
		</div>
		<div class="line"></div>

		<?php
			$db = new SQLite3('hackday.db');
			$hackdays = $db->query("select * from hackdays order by ordering desc");
			while($hackday = $hackdays->fetchArray()):
		?>
		<div class="title"><div class="number">#<?=$hackday['ordering'] ?></div><?=date("F j, Y", strtotime($hackday['date'])) ?> @ <?=$hackday['location'] ?>
		<div class="container">
			<?php
				$hacks = $db->query("select * from hacks left join hackers on hacks.hacker_id = hackers.id where hackday_id = ".$hackday['id']);
				$numHacks = $db->querySingle("select count(*) from hacks where hackday_id = ".$hackday['id']);
				if($numHacks):
					while($hack = $hacks->fetchArray()):
			?>
				<div class="hack">
					<div class="image"><img src="img/<?=$hackday[1] ?>/<?=$hack[5] ?>" title="<?=$hack[2] ?>" alt="<?=$hack[2] ?>" /></div>
					<div class="title">
						<strong>
							<?php if($hack[4] != NULL): ?>
								<a href="<?=$hack[4]?>" target="_blank"><?=$hack[2] ?></a>
							<?php else: ?>
								<?=$hack[2] ?>
							<?php endif; ?>
						</strong>
						by
						<a href="<?=$hack[10] ?>" target="_blank"><?=$hack[9] ?></a>
					</div>
					<div class="description">
						<?=$hack[3] ?>
					</div>
				</div>
			<?php
					endwhile;
				else:
			?>
				<div class="next">
					The next SE Hack Day is scheduled for <?=date("F j, Y", strtotime($hackday['date'])) ?> at <?=$hackday['location'] ?>. Check back later for more info.
				</div>			
			<?php
				endif;
			?>
		</div>
		<?php
			endwhile;
		?>
		<div id="footer">
			site by <a href="http://www.petersobot.com" target="_blank">Peter Sobot</a> | <a href="mailto:sehackday@petersobot.com">contact SE Hack Day</a>
		</div>
	</body>
</html>
<?php
	$db->close();
