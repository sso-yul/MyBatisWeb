package com.earth.heart.domain;

public class Person {

	private String name;
	private int age;
	
	//기본생성자 추가 . 생성자 오버로딩하기 때문에
	public Person() {}

	@Override
	public String toString() {
		return "Person [name=" + name + ", age=" + age + "]";
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public Person(String name, int age) {
		//super();
		this.name = name;
		this.age = age;
	}
	
	
}
