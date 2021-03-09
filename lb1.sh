#!/bin/bash
echo "Программа для работы с паролями"
echo "С помощью данной программы вы можете запрашивать имя пользователя, запрашивать минимальное и максимальное время жизни пароля," 
echo "запрашивать пароль и устанавливать данному пользователю новый пароль с заданными ограничениями"
echo "Разработчик: Фокина Яна Игоревна 737-1"

while true; do
	error=0
	# Ввод имени проверяемого пароля
	echo "Введите имя пользователя: "
	read username

	grep "$username" /etc/passwd >/dev/null
	if [ $? -ne 0 ]; then
		echo "Нет пользователя с именем \"$username\"" >&2 # Вывод stderr
		error=-1
		continue
	else
		echo "Пользователь \"$username\" существует"
	fi

	# Вывод информации о пользователе
	echo "Данные о пользователе"
	echo `passwd -S $username`

	# Ввод минимального времени жизни пароля
	echo "Введите минимальное время жизни пароля"
	while true; do
		read minlifetime
		if (echo "$minlifetime" | grep -E -q "^?[0-9]+$"); then
			break
		else
			echo "$minlifetime не является числом, попробуйте ещё раз" >&2
			error=-1
		fi
	done

	passwd -n $minlifetime $username

	# Ввод максимального времени жизни пароля
	echo "Введите максимальное время жизни пароля"
	while true; do
		read maxlifetime
		if (echo "$maxlifetime" | grep -E -q "^?[0-9]+$"); then
			break
		else
			echo "$maxlifetime не является числом, попробуйте ещё раз" >&2
			error=-1
		fi
	done

	passwd -x $maxlifetime $username

	echo "Хотите сменить пароль? (введите y, если да)"
	read answer
	if [[ $answer == "y" ]]; then
		echo "Введите пароль пользователя"
		while true; do
			read password
			if (("${#password}" >= 8)); then
				break
			else
				echo "$password слишком короткий" >&2
				error=-1
			fi
		done
		echo -e "$password\n$password\n" | passwd $username
	fi

	echo "Хотите изменить пароль другого пользователя? (введите y, если да)"
	read answer
	if [[ $answer == "y" ]]; then
		continue
	else
		echo "Завершаю выполнение..."
		break
	fi
done
exit $error