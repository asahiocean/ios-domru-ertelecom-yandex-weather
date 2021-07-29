# Тестовое задание в [Дом.ru](https://dom.ru) ([ЭР-Телеком](https://ertelecom.ru))
Указан максимально придуманный функционал. Реализация абсолютно всех задач не обязательна.

Подгружать данные по погоде за 7 дней с использованием Яндекс.Погода API. Вывод данных - по желанию. Обязательно с иконкой погоды на день. При нажатии на день открывается отдельная страница, на которой подгружаются и отображаются данные погоды по часам. При работе с сетью использовать Alamofire или Moya. Загруженные данные сохранять на устройстве, используя Realm. При повторном открытии приложения отображать данные с устройства, параллельно обновлять данные и отображать новые, если что-то поменялось.

---

<img width="256" alt="example" src="https://raw.githubusercontent.com/asahiocean/ERTelecom-Dom.ru/main/example.gif">

1. Архитектура VIPER
2. Работа с сетью: URLSession, URLRequest и Moya
3. Firebase для аналитики
4. Realm, UserDefaults и URLCache для хранения
