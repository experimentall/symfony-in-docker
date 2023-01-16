<?php

declare(strict_types=1);

namespace App\Tests\Unit\Controller;

use Symfony\Bundle\FrameworkBundle\Test\KernelTestCase;
use App\Controller\BaseController;
use Symfony\Component\DependencyInjection\ParameterBag\ParameterBagInterface;
use Symfony\Component\HttpFoundation\Response;

class BaseControllerTest extends KernelTestCase
{
    public function testInvokeShouldReturnResponse()
    {
        $parameterBag = $this->createMock(ParameterBagInterface::class);
        $parameterBag->expects(self::once())->method('get')->with('kernel.project_dir')->willReturn('/var/www/html');
        $controller = new BaseController($parameterBag);

        $this->assertInstanceOf(Response::class, $controller->__invoke());
    }
}
