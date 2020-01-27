%Assignment 1 for ELEC 4700 - Philippe Masson

timestep = 1e-3; %1ms
region_size_x = 200e-9; %meter
region_size_y = 100e-9; %meter
numParticles = 100;
temperature = 300; %Kelvin
mass_electron = 9.10938356e-31; %electron rest mass [kg]
mass_effective = 0.26*mass_electron; %electron effective mass [kg]
const_boltzman = 1.38064852e-23; %Boltzman constant [m^2 kg / s^2 K]
velocity_thermal = sqrt(const_boltzman*temperature/mass_effective); %TODO %thermal velocity

particleArray = [];

%initialize the particles
for i = 1:numParticles
    %init positions
    particleArray(i,1) = rand * region_size_x;
    particleArray(i,2) = rand * region_size_y;
    
    %init velocity
    particleArray(i,3) = velocity_thermal; %velocity magnitude
    particleArray(i,4) = (rand * 2) - 1; %x-direction (normalized)
    particleArray(i,5) = sqrt(1-particleArray(i,4)^2); %y-direction (normalized)
        
end

simLength = 1000;
for simCount = 1:simLength
    currTime = simCount * timestep;
    
    %update particle positions
    
    
    scatter(particleArray(:,1), particleArray(:,2));
    pause(0.001);
    
end