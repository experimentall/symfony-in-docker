<?php

namespace App\Tests\Functional;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class HomeTest extends WebTestCase
{
	public function testHomeUrl(): void
	{
		$client = static::createClient();
		$client->request('GET', '/');

		$this->assertResponseIsSuccessful();
	}
}
