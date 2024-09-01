# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Dummy::Application, type: :routing do
  describe WelcomeController, type: :routing do
    describe 'routing' do
      it { expect(get: 'http://main-domain.local/').to route_to({ 'controller' => 'welcome', 'action' => 'index' }) }

      it { expect(get: 'http://main-domain.local/a-propos').to  route_to({ 'controller' => 'pages', 'action' => 'about', 'locale' => 'fr' }) }
      it { expect(get: 'http://main-domain.local/pt/quem-e').to route_to({ 'controller' => 'pages', 'action' => 'about', 'locale' => 'pt' }) }
      it { expect(get: 'http://main-domain.local/es/sobre').to  route_to({ 'controller' => 'pages', 'action' => 'about', 'locale' => 'es' }) }
      it { expect(get: 'http://main-domain.local/en/about').to  route_to({ 'controller' => 'pages', 'action' => 'about', 'locale' => 'en' }) }
    end
  end

  describe CategoriesController, type: :routing do
    describe 'test_inflections' do
      it { expect(get: 'http://main-domain.local/categories/nouveau').to  route_to({ 'controller' => 'categories', 'action' => 'new', 'locale' => 'fr' }) }
      it { expect(get: 'http://main-domain.local/es/categorias/nueva').to route_to({ 'controller' => 'categories', 'action' => 'new', 'locale' => 'es' }) }
      it { expect(get: 'http://main-domain.local/pt/categorias/nueva').to route_to({ 'controller' => 'categories', 'action' => 'new', 'locale' => 'pt' }) }
      it { expect(get: 'http://main-domain.local/en/categories/new').to   route_to({ 'controller' => 'categories', 'action' => 'new', 'locale' => 'en' }) }
    end
  end

  describe Admin::CarsController, type: :routing do
    describe 'test_namespaces' do
      it { expect(get: 'http://main-domain.local/administrateur/voitures').to route_to({ 'controller' => 'admin/cars', 'action' => 'index', 'locale' => 'fr' }) }
      it { expect(get: 'http://main-domain.local/es/administrador/coches').to route_to({ 'controller' => 'admin/cars', 'action' => 'index', 'locale' => 'es' }) }
      it { expect(get: 'http://main-domain.local/pt/administrador/carros').to route_to({ 'controller' => 'admin/cars', 'action' => 'index', 'locale' => 'pt' }) }
      it { expect(get: 'http://main-domain.local/en/administrator/cars').to   route_to({ 'controller' => 'admin/cars', 'action' => 'index', 'locale' => 'en' }) }
    end
  end

  describe SoldCars::CarsController, type: :routing do
    describe 'test_namespaces' do
      it { expect(get: 'http://main-domain.local/vendues/voitures').to   route_to({ 'controller' => 'sold_cars/cars', 'action' => 'index', 'locale' => 'fr' }) }
      it { expect(get: 'http://main-domain.local/es/vendidos/coches').to route_to({ 'controller' => 'sold_cars/cars', 'action' => 'index', 'locale' => 'es' }) }
      it { expect(get: 'http://main-domain.local/pt/vendidos/carros').to route_to({ 'controller' => 'sold_cars/cars', 'action' => 'index', 'locale' => 'pt' }) }
      it { expect(get: 'http://main-domain.local/en/sold/cars').to       route_to({ 'controller' => 'sold_cars/cars', 'action' => 'index', 'locale' => 'en' }) }
    end
  end
end
