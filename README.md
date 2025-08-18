# Fast Marketplace

## Visão Geral
O **Fast Marketplace** é um aplicativo de marketplace de serviços rápidos, criado para conectar vizinhos que precisam de ajuda com vizinhos que podem oferecer serviços, como pequenos reparos, montagem de móveis ou aulas.  

O app foi construído com as mais recentes tecnologias da Apple, **Swift** e **SwiftUI**, seguindo a arquitetura **MVVM (Model-View-ViewModel)** para garantir um código limpo, escalável e de fácil manutenção.

## Arquitetura e Tecnologia
- **Linguagem:** Swift  
- **Interface:** SwiftUI  
- **Arquitetura:** MVVM (Model-View-ViewModel)  
- **Persistência:** Core Data para dados offline. Opcional Firebase para backend em nuvem  
- **Plataforma:** iOS 16.0+ (Xcode 15+)

## Estrutura do Código
O projeto está organizado em grupos lógicos para separar responsabilidades, refletindo a arquitetura MVVM:

- **Models:** Contém as estruturas de dados fundamentais (`Service`, `User`, `Request`).  
- **ViewModels:** Lógica de negócios e gerenciamento de estado. Atua como intermediário entre as Views e os Models.  
- **Views:** Onde a interface do usuário é construída. As views são reativas e se atualizam com base nos dados do ViewModel.  
- **Services:** Camada para abstrair a lógica de persistência de dados (Core Data, Firebase).  
- **AppEntry:** Contém o arquivo principal do aplicativo.  
- **Utils:** Utilitários e extensões comuns.  

## Funcionalidades Implementadas
- **Login Opcional:** Usuários podem navegar e visualizar serviços sem criar conta.  
- **Feed de Serviços:** Lista de serviços disponíveis na tela inicial.  
- **Adicionar Serviço:** Formulário para publicar um novo serviço.  
- **Detalhes do Serviço:** Tela com informações detalhadas.  
- **Solicitação de Serviço:** Funcionalidade para solicitar um serviço via pop-up.  
- **Perfil do Usuário:** Gerenciamento dos serviços publicados e do histórico de solicitações.  
- **Persistência Offline:** Core Data permite a navegação e a criação de dados mesmo sem internet.
