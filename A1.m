%Assignment 1 for ELEC 4700 - Philippe Masson

timestep = 1e-14; %10fs
region_size_x = 200e-9; %meter
region_size_y = 100e-9; %meter
numParticles = 10000;
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
    if(rand > 0.5)
        particleArray(i,5) = particleArray(i,5) * -1;
    end
        
end

simLength = 1000;
figure(1)
for simCount = 1:simLength
    currTime = simCount * timestep;
    
    %update particle positions
    new_xPos = particleArray(:,1) + timestep * particleArray(:,3) .* particleArray(:,4);
    new_yPos = particleArray(:,2) + timestep * particleArray(:,3) .* particleArray(:,5);
    
    %check boundary conditions
    for i = 1:numParticles
        if(new_xPos(i) < 0) %bounce off boundary
            new_xPos(i) = abs(new_xPos(i) - particleArray(i,1));
            particleArray(i,4) = particleArray(i,4) * -1; %swap direction
        elseif(new_xPos(i) > region_size_x) %bounce off boundary
            new_xPos(i) = region_size_x - abs(new_xPos(i) - particleArray(i,1));
            particleArray(i,4) = particleArray(i,4) * -1; %swap direction
        end
        
        if(new_yPos(i) < 0) %bounce off boundary
            new_yPos(i) = abs(new_yPos(i) - particleArray(i,2));
            particleArray(i,5) = particleArray(i,5) * -1; %swap direction
        elseif(new_yPos(i) > region_size_y) %bounce off boundary
            new_yPos(i) = region_size_y - abs(new_yPos(i) - particleArray(i,2));
            particleArray(i,5) = particleArray(i,5) * -1; %swap direction
        end
    end
    
    particleArray(:,1) = new_xPos;
    particleArray(:,2) = new_yPos;
    
    scatter(particleArray(:,1), particleArray(:,2), 5);
    axis([0, region_size_x, 0, region_size_y]);
    pause(0.01);
    
end