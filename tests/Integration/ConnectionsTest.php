<?php

declare(strict_types=1);

namespace App\Tests\Integration;

use Symfony\Bundle\FrameworkBundle\Test\KernelTestCase;
use Doctrine\Persistence\ManagerRegistry;
use \Exception;

class ConnectionsTest extends KernelTestCase
{
    private ManagerRegistry $mr;

    protected function setUp(): void
    {

        self::bootKernel();
        $this->mr = static::getContainer()->get(ManagerRegistry::class);
    }

    public function testConnection(): void
    {
        foreach ($this->mr->getConnections() as $name => $con) {
            $exception = '';
            try {
                $con->connect();
            } catch (Exception $e) {
                $exception = $e->getMessage();
            }
            
            $this->assertEmpty($exception, \sprintf('%s: %s', $name, $exception));
            $this->assertTrue($con->isConnected(), sprintf('Unable to connect with connection named "%s"', $name));
            $con->close();
        }
    }
}
