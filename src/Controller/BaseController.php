<?php

declare(strict_types=1);

namespace App\Controller;

use Symfony\Component\DependencyInjection\ParameterBag\ParameterBagInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Attribute\AsController;
use Symfony\Component\HttpKernel\Kernel;
use Symfony\Component\Routing\Annotation\Route;

use function Symfony\Component\String\u;

#[AsController]
#[Route('/', name: 'home')]
class BaseController
{
    public function __construct(private ParameterBagInterface $params)
    {
    }

    public function __invoke(): Response
    {
        $version = Kernel::VERSION;
        $projectDir = u('')->join([$this->params->get('kernel.project_dir'), \DIRECTORY_SEPARATOR]);
        $docVersion = \substr(Kernel::VERSION, 0, 3);

        \ob_start();
        include $projectDir.'/vendor/symfony/http-kernel/Resources/welcome.html.php';

        return new Response((string) \ob_get_clean(), Response::HTTP_OK);
    }
}
