%Assignment 1 for ELEC 4700 - Philippe Masson
close all;
clear;
tic;
timestep = 1e-14; %10fs
region_size_x = 200e-9; %meter
region_size_y = 100e-9; %meter
numParticles = 10000;
simLength = 1000; %number of iterations of the simulation
temperature = 300; %Kelvin
mass_electron = 9.10938356e-31; %electron rest mass [kg]
mass_effective = 0.26*mass_electron; %electron effective mass [kg]
const_boltzman = 1.38064852e-23; %Boltzman constant [m^2 kg / s^2 K]
velocity_thermal = sqrt(const_boltzman*temperature/mass_effective); %thermal velocity
collisionTime = 0.2e-12; %time between particle collisions

%particle array is in following format: 
%xPos, yPos, Velocity Mag, xDir(norm), yDir(norm), TimeSinceLastScatter
particleArray = [];

tempArrary = []; %array to store temperature history
particleXPos7Array = []; %array to store 7 X positions history
particleYPos7Array = []; %array to store 7 Y positions history
scatterPathSum = 0; %store the summed path between scatters
scatterTimeSum = 0; %store the summed time between scatters
numScatters = 0; %total number of particles scattered

scatterProbability = 1 - exp(-timestep/collisionTime); %probability of particle being scattered

%Specs for boxes
box_Left = 80e-9;
box_Right = 120e-9;
box_Top = 60e-9;
box_Bottom = 40e-9;

%change both of these to 0 if you want part 1 plots
Part2 = 1; %change this to 1 & Part3 to 0 if you want part 2 plots
Part3 = 1; %change this to 1 if you want part 3 plots

%initialize the particles
for i = 1:numParticles
    %init positions
    particleArray(i,1) = rand * region_size_x;
    particleArray(i,2) = rand * region_size_y;
    
    if(Part3 == 1)
        while(particleArray(i,1) >= box_Left && particleArray(i,1) <= box_Right && (particleArray(i,2) <= box_Bottom || particleArray(i,2) >= box_Top))
            %pick new location, you're in the boxes!
            particleArray(i,1) = rand * region_size_x;
            particleArray(i,2) = rand * region_size_y;
        end
    end
    
    if(Part2 == 1 || Part3 == 1)
        vth = randn*velocity_thermal + velocity_thermal;
    else
        vth = velocity_thermal;
    end
    %init velocity
    particleArray(i,3) = vth; %velocity magnitude
    particleArray(i,4) = (rand * 2) - 1; %x-direction (normalized)
    particleArray(i,5) = sqrt(1-particleArray(i,4)^2); %y-direction (normalized)
    if(rand > 0.5)
        particleArray(i,5) = particleArray(i,5) * -1;
    end
    
    particleArray(i,6) = 0; %set time since last scatter to 0
        
end

%plot histogram of velocities
figure(1);
histogram(particleArray(:,3));
title(['Histogram of Initial Velocity Distribution, Mean = ' num2str(mean(particleArray(:,3)))]);
xlabel('Thermal Velocity of a Given Particle (m/s)');
ylabel('Counts');

for simCount = 1:simLength
    currTime = simCount * timestep;
        
    %scatter particles
    for i = 1:numParticles
        %update time since last scatter
        particleArray(i,6) = particleArray(i,6) + timestep;
        
        if(rand <= scatterProbability) %scatter the particle
            scatterPathSum = scatterPathSum + (particleArray(i,6)*particleArray(i,3)); %store path between scatters
            scatterTimeSum = scatterTimeSum + particleArray(i,6); %store time between scatters
            particleArray(i,6) = 0; %reset time since last scatter            
            numScatters = numScatters + 1;
            particleArray(i,3) = randn*velocity_thermal + velocity_thermal; %randomize velocity
            particleArray(i,4) = (rand * 2) - 1; %x-direction (normalized)
            particleArray(i,5) = sqrt(1-particleArray(i,4)^2); %y-direction (normalized)
            if(rand > 0.5)
                particleArray(i,5) = particleArray(i,5) * -1;
            end
        end
    end
    
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
        
        %You're in the boxes
        if(new_xPos(i) >= box_Left && new_xPos(i) <= box_Right && (new_yPos(i) <= box_Bottom || new_yPos(i) >= box_Top))
            %re-thermalize since you hit a box
            %particleArray(i,3) = randn*velocity_thermal + velocity_thermal; %randomize velocity
            if(particleArray(i,1) < box_Left)
                tempx = box_Left - abs(new_xPos(i) - particleArray(i,1));
                if(~(tempx >= box_Left && tempx <= box_Right && (new_yPos(i) <= box_Bottom || new_yPos(i) >= box_Top))) %not in box
                    new_xPos(i) = tempx;
                    particleArray(i,4) = particleArray(i,4) * -1; %swap direction
                end
            elseif(particleArray(i,1) > box_Right)
                tempx = box_Right + abs(new_xPos(i) - particleArray(i,1));
                if(~(tempx >= box_Left && tempx <= box_Right && (new_yPos(i) <= box_Bottom || new_yPos(i) >= box_Top))) %not in box
                    new_xPos(i) = tempx;
                    particleArray(i,4) = particleArray(i,4) * -1; %swap direction
                end
            elseif(particleArray(i,2) < box_Top)
                tempy = box_Top - abs(new_yPos(i) - particleArray(i,2));
                if(~(new_xPos(i) >= box_Left && new_xPos(i) <= box_Right && (tempy <= box_Bottom || tempy >= box_Top))) %not in box
                    new_yPos(i) = tempy;
                    particleArray(i,5) = particleArray(i,5) * -1; %swap direction
                end
            elseif(particleArray(i,2) > box_Bottom)
                tempy = box_Bottom + abs(new_yPos(i) - particleArray(i,2));
                if(~(new_xPos(i) >= box_Left && new_xPos(i) <= box_Right && (tempy <= box_Bottom || tempy >= box_Top))) %not in box
                    new_yPos(i) = tempy;
                    particleArray(i,5) = particleArray(i,5) * -1; %swap direction
                end
            end
        end
    end
    
    
    particleArray(:,1) = new_xPos;
    particleArray(:,2) = new_yPos;
    
    %Scatter plotting of the particles uncomment if you wanna see live plot
%     figure(4);
%     scatter(particleArray(:,1), particleArray(:,2), 5);
%     axis([0, region_size_x, 0, region_size_y]);
%     title(['Scatter Plot of Particles in a box. Iteration: ', num2str(simCount)]);
%     xlabel('X (m)');
%     ylabel('Y (m)');

    %save the particle position history to be plotted later
     particleXPos7Array(1:7,simCount) = particleArray(1:7,1);
     particleYPos7Array(1:7,simCount) = particleArray(1:7,2);

    %save the temperature history to be plotted later
    tempArray(simCount) = mean(particleArray(:,3))^2*mass_effective/const_boltzman;


    %pause(0.0001); %quick pause so that the graphs can be displayed live
    if(mod(simCount,100) == 0) %Update the console with current simCount
        disp(['simcount: ', num2str(simCount), ' of ', num2str(simLength)]);
    end
end

disp('----------');
disp(['Simulation ended successfully after ', num2str(toc), ' seconds.']);
disp('----------');
disp('Simulation Specs:');
disp(['Timestep Size: ', num2str(timestep), ' seconds']);
disp(['Number of Simulation Iterations: ', num2str(simLength)]);
disp(['Number of Particles: ', num2str(numParticles)]);
disp('----------');
disp('Simulation Results:');
disp(['Mean Free Path (MFP): ', num2str(scatterPathSum/numScatters), ' meters']);
disp(['Time between Collisions: ', num2str(scatterTimeSum/numScatters), ' seconds']);

%plot the trajectory of the particles
figure(10);
hold on;
for i = 1:7
    plot(particleXPos7Array(i,:),particleYPos7Array(i,:));
end
xlim([0,region_size_x]);
ylim([0,region_size_y]);
title(['Particle Trajectory, Simulation Count: ', num2str(simCount), ', Timestep: ', num2str(timestep)]);
xlabel('X (m)');
ylabel('Y (m)');

%plot the temperature over time
figure(11);
x = linspace(timestep,simLength*timestep,simLength);
plot(x,tempArray);
title('Average Temperature Over Time');
xlabel('Time (s)');
ylabel('Temperature (K)');

%plot a density map
figure(12);
hist3([particleArray(:,1), particleArray(:,2)],'Nbins',[40,20],'CdataMode','auto');
colormap('hot');
colorbar;
view(2);
title('Density Heatmap');
xlabel('X (m)');
ylabel('Y (m)');