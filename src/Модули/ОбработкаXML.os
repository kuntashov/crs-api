#Использовать xml-parser

#Область СлужебныйПрограммныйИнтерфейс

Функция ПрочитатьОтветИзТекста(Тест) Экспорт
	ПутьКФайлу = ВременныйФайлXML(Тест);
	Возврат ПрочитатьОтчетИзФайла(ПутьКФайлу);
КонецФункции

Функция ПрочитатьОтчетИзФайла(ПутьКФайлу) Экспорт
	
	ПроцессорXML = Новый СериализацияДанныхXML();
	РезультатЧтения = ПроцессорXML.ПрочитатьИзФайла(ПутьКФайлу);
	Если ЭтоОтветСОшибкой(РезультатЧтения) Тогда
		Возврат ОбработаннаяОшибка(РезультатЧтения);
	КонецЕсли;

	Ответ = Новый ОтветСервиса();
	Ответ.РезультатЧтения = РезультатЧтения;
	Возврат Ответ;
	
КонецФункции

Функция ПрочитатьПользователяИзXML(Данные) Экспорт
	
	Структура = Новый Структура;
	
	ИмяФайла = ПолучитьИмяВременногоФайла("xml");
	
	ТД = Новый ТекстовыйДокумент();
	ТД.УстановитьТекст(Данные);
	ТД.Записать(ИмяФайла, "UTF-8");
	
	ПроцессорXML = Новый СериализацияДанныхXML();
	РезультатЧтения = ПроцессорXML.ПрочитатьИзФайла(ИмяФайла);
	ПользовательXML = РезультатЧтения["call_return"]["_Элементы"]["user"];
	Информация = ПользовательXML["info"];
	Для Каждого КлючЗначение Из Информация Цикл
		Если КлючЗначение.Ключ = "id" Тогда
			Структура.Вставить("Идентификатор", КлючЗначение.Значение["_Атрибуты"]["value"]);
		ИначеЕсли КлючЗначение.Ключ = "name" Тогда
			Структура.Вставить("Имя", КлючЗначение.Значение["_Атрибуты"]["value"]);
		ИначеЕсли КлючЗначение.Ключ = "password" Тогда
			Структура.Вставить("ХешПароля", КлючЗначение.Значение["_Атрибуты"]["value"]);
		ИначеЕсли КлючЗначение.Ключ = "rights" Тогда
			Структура.Вставить("Права", КлючЗначение.Значение["_Атрибуты"]["value"]);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Структура;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОбработаннаяОшибка(РезультатЧтения)
	Значение = РезультатЧтения.Получить("call_exception");
	Содержимое = СокрЛП(Значение._Значение);
	Ошибка = СодержимоеИзBase64(Содержимое);

	Ответ = Новый ОтветСервиса;
	Ответ.ЕстьОшибка = Истина;
	Ответ.СодержаниеОшибки = Ошибка;

	Возврат Ответ;
КонецФункции

Функция ЭтоОтветСОшибкой(РезультатЧтения)
	Значение = РезультатЧтения.Получить("call_exception");
	Возврат Не Значение = Неопределено;
КонецФункции

Функция ВременныйФайлXML(Текст)
	Путь = ПолучитьИмяВременногоФайла("xml");
	ТекстовыйДокумент = Новый ТекстовыйДокумент();
	ТекстовыйДокумент.УстановитьТекст(Текст);
	ТекстовыйДокумент.Записать(Путь, КодировкаТекста.UTF8);
	ТекстовыйДокумент = Неопределено;
	Возврат Путь;
КонецФункции

Функция СодержимоеИзBase64(ВходящиеДанные)
	ДД = Base64Значение(ВходящиеДанные);
	ВременныйФайл = ПолучитьИмяВременногоФайла("txt");
	ДД.Записать(ВременныйФайл);
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ВременныйФайл, КодировкаТекста.UTF8);
	Содержимое = ТекстовыйДокумент.ПолучитьТекст();
	ТекстовыйДокумент = Неопределено;
	УдалитьФайлы(ВременныйФайл);
	Возврат Содержимое; 
КонецФункции

#КонецОбласти