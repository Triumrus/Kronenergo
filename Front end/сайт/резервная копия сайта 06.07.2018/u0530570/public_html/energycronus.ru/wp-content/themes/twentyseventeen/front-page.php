<?php
/**
 * The front page template file
 *
 * If the user has selected a static page for their homepage, this is what will
 * appear.
 * Learn more: https://codex.wordpress.org/Template_Hierarchy
 *
 * @package WordPress
 * @subpackage Twenty_Seventeen
 * @since 1.0
 * @version 1.0
 */

get_header(); ?>

<header>
	<div class="menutop">
		<div class="conainer">
		<?php wp_nav_menu('menu=Верхнее меню'); ?>
		
		</div>
	</div>
</header>
<div class="section1"data-parallax="scroll" data-image-src="http://energycronus.ru/images/section1.jpg">
	<div class="conainer" >
		<div class="rightbn">
			<div class="h1"><span style="color:#f6c536">КРОН</span>ЭНЕРГО</div>
			<div class="h2">АВТОМАТИЗИРОВАННАЯ АНАЛИТИКА</div>
		</div>
			<div class="desc"><span style="font-size:52px">КРОНЭНЕРГО -</span><br>самообучаемый робот-аналитик, который с высокой точностью<br>предсказывает количество	потребляемой электроэнергии
			</div>
		<div class="form1"><div class="titl">Получить демо</div><?php echo do_shortcode('[contact-form-7 id="27" title="Контактная форма 1"]');?></div>
	</div>
</div>


<div class="section2"><a id="about"></a>
	<div class="conainer">
		<div class="rightbn">
			<div style="display:none"><div class="h3"><span style="color:#f6c536">КРОН</span>ЭНЕРГО</div>
			<div class="h4">АВТОМАТИЗИРОВАННАЯ АНАЛИТИКА</div></div>
		
			<div class="desc2">МЫ СМОГЛИ УВЕЛИЧИТЬ ТОЧНОСТЬ ПРОГНОЗА, РЕШИВ ОДНУ ИЗ ПРОБЛЕМ	РЫНКА НА СУТКИ ВПЕРЕД
			</div>
			
			<div class="desc3"><b>РОБОТ-АНАЛИТИК –</b> это математический алгоритм, построенный на основе машинного обучения для автоматического предсказания потребления электроэнергии на сутки вперед
		</div>
	</div>
	
	<div class="row">
		<div class="left">РОБОТ-АНАЛИТИК<br>
КРОНЭНЕРГО<br>
ИСПОЛЬЗУЕТ<br>
</div>

		<div class="rblock">
			<ul><li>исторические данные;</li>
				<li>производственный профиль;</li>
				<li>продолжительность дня;</li>
				<li>погодные условия;</li>
				<li>производственный календарь.</li></ul>
		</div>
	
	</div><div class="row_link"><a href="#contact_form_pop" class="fancybox-inline getdemo">Получить демо</a></div>
</div>

</div>

<div class="section3">
	<div class="conainer"><a id="preim"></a>
	<div class="titlr">Преимущества робота-аналитика</div>
	<div class="row33">
		<div class="fifth">
			<div class="roundimg"><img src="images/icon1.png" class="iconf"></div>
			<div class="namepre">НАДЕЖНОСТЬ</div>
			<div class="textpre">
			Все используемые математические модели тестируются через train/test.
			</div>
		</div>
		<div class="fifth">
			<div class="roundimg"><img src="images/icon2.png" class="iconf"></div>
			<div class="namepre">ИНДИВИДУАЛЬНЫЙ ПОДХОД</div>
			<div class="textpre">
			Персональная настройка робота – аналитика под каждый объект
			</div>
		</div>
		<div class="fifth">
			<div class="roundimg"><img src="images/icon3.png" class="iconf"></div>
			<div class="namepre">ЛЕГКОСТЬ ИСПОЛЬЗОВАНИЯ</div>
			<div class="textpre">
			После настройки робот работает в автоматическом режиме.
			</div>
		</div>
		<div class="fifth">
			<div class="roundimg"><img src="images/icon4.png" class="iconf"></div>
			<div class="namepre">ГАРАНТИРОВАННЫЙ РЕЗУЛЬТАТ</div>
			<div class="textpre">
			Мы готовы сравнивать наш прогноз с любым другим прогнозом, поскольку полностью уверены в своем продукте.
			</div>
		</div>
		<div class="fifth">
			<div class="roundimg"><img src="images/icon5.png" class="iconf"></div>
			<div class="namepre">БЕСПЛАТНЫЙ ТЕСТОВЫЙ ПЕРИОД</div>
			<div class="textpre">
			
			</div>
		</div>
	
	</div>
	<div class="row_link"><a href="#contact_form_pop" class="fancybox-inline getdemo">Получить демо</a></div>
	</div>
</div>
<div class="section4">
	<div class="conainer"><a id="shema"></a>
	<div class="title4">Схема работы с нами</div>
			<div class="etap1">
		<div class="title41">Этап I</div>
		
		<div class="row42">
			<div class="fourth">
				<div class="number">1</div>
				<div class="text4">
					Предоставление исторических данных за год
				</div>
			</div>
			<div class="fourth">
				<div class="number">2</div>
				<div class="text4">
					КронЭнерго анализирует данные и создает математической модели
				</div>
			</div>
			<div class="fourth">
				<div class="number">3</div>
				<div class="text4">
					КронЭнерго делает прогноз, на котором показывается экономия для потребителя
				</div>
			</div>
			<div class="fourth">
				<div class="number">4</div>
				<div class="text4">
					КронЭнерго на основании экономии составляет коммерческое предложение 
				</div>
			</div>
		
		</div>
		</div>
		<div class="etap3">
		<div class="title41 etap2">Этап II</div>
		
		<div class="row42">
			<div class="fourth">
				<div class="number">1</div>
				<div class="text4">
					<b>Как это работает?</b><br><br> Мы предоставляем доступ к личному кабинету, Вы загружаете фактические показания электроэнергии за вчерашний день и получаете прогноз электроэнергии на завтрашний день.
				</div>
			</div>
			<div class="fourth">
				<div class="number">2</div>
				<div class="text4">
					<b>Какое нужно для этого оборудование?</b><br><br> Компьютер с доступом в интернет.
				</div>
			</div>
			<div class="fourth">
				<div class="number">3</div>
				<div class="text4">
					<b>Стоимость доступа после окончания пробного периода</b><br><br> Процент от экономии(обсуждается индивидуально)
				</div>
			</div>
			<div class="fourth">
				<div class="number">4</div>
				<div class="text4">
					<b>Как получить доступ к пробному периоду?</b><br><br> Напишите нам pochta@pochta.ru
				</div>
			</div>
		
		</div>
		</div>
		<div class="row_link"><a href="#contact_form_pop" class="fancybox-inline getdemo">Получить демо</a></div>
		<div style="display:none" class="fancybox-hidden">
			<div id="contact_form_pop"> 
				<div class="titleform">Заявка на получение демо</div>
			<?php echo do_shortcode('[contact-form-7 id="33" title="Попап"]'); ?>
		</div>
		</div>
		
		
	</div>
</div>
<div class="section5">
	<div class="conainer"><a id="plany"></a>
		<div class="title4">Как мы планируем развиваться</div>
		
		<div class="text"><b>Мы поставили перед собой амбициозную задачу создать алгоритм, который с максимально возможной точностью предсказывает цены на покупку и продажу электроэнергии на рынке.</b><br><br>

Как известно, торговля происходит путем установления равновесной цены на основе спроса и предложения. Производители с ценовыми заявками выше равновесной цены и потребители с ценовой заявкой ниже равновесной цены теряют возможность попасть в торговый график. Мы планируем минимизировать для своих клиентов риски на рынке благодаря работе нового алгоритма. <br><br>Также планируем объединить две аналитики (прогноз потребления электроэнергии и ценовой прогноз) для поиска локальной точки максимума в вопросе экономии электроэнергии.

</div>
<div class="desc2 cent"></div>
<div class="grafik"></div>
	<div class="row_link"><a href="#contact_form_pop" class="fancybox-inline getdemo">Получить демо</a></div>
	</div>
</div>
<div class="section6">
	<div class="conainer"><a id="contact"></a>
		<div class="titlr">Контакты</div>
		
		<div class="mapp">
		<script type="text/javascript" charset="utf-8" async src="https://api-maps.yandex.ru/services/constructor/1.0/js/?um=constructor%3A528fff468cc60a0b835519de9a6cf579981a737114e9b82b1042dc8479f5f21a&amp;width=550&amp;height=400&amp;lang=ru_RU&amp;scroll=false"></script>
		</div>
		
		<div class="adress">
		<div class="adrr">Москва, 2-я Синичкина улица, 9А</div>
		<div class="mail">info@kronenergo.ru</div>
		<div class="phone">+7 123 456 78 90</div>
		</div>
	</div>
</div>
<div id="toTop">Наверх</div>

<?php get_footer();
